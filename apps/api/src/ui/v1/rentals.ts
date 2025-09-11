// @ts-nocheck
export {};
// src/api/v1/rentals.js
const router = require("express").Router();
const prisma = require("../../prisma");

/* ------------------------------ Utils locais ------------------------------ */
function parsePositiveInt(v, def) {
  const n = parseInt(v, 10);
  return Number.isFinite(n) && n > 0 ? n : def;
}
function coerceIsoDate(val) {
  if (val == null) return null;
  const d = new Date(val);
  return Number.isNaN(d.getTime()) ? null : d;
}
async function findConflict({ vehicleId, start, end, excludeId = null }) {
  return prisma.rental.findFirst({
    where: {
      vehicleId: String(vehicleId),
      // conflito clássico: começa antes do fim E termina depois do início
      startDate: { lt: end },
      endDate: { gt: start },
      // regra atual: só 'confirmed' bloqueia agenda
      status: { in: ["confirmed"] },
      ...(excludeId ? { NOT: { id: String(excludeId) } } : {}),
    },
    select: { id: true },
  });
}

/* ------------------------------- Listar (GET) ------------------------------ */
/**
 * GET /api/v1/rentals
 * Ex.: ?page=1&limit=20&tenantId=...&status=confirmed&startFrom=2025-09-01&endTo=2025-09-30
 */
router.get("/", async (req, res) => {
  try {
    const page = parsePositiveInt(req.query.page, 1);
    const limit = parsePositiveInt(req.query.limit, 20);
    const skip = (page - 1) * limit;

    const where = {};
    if (req.query.tenantId) where.tenantId = String(req.query.tenantId);
    if (req.query.status) where.status = String(req.query.status);

    // filtros de período (opcionais)
    const startFrom = req.query.startFrom ? new Date(req.query.startFrom) : null; // >= startDate
    const endTo = req.query.endTo ? new Date(req.query.endTo) : null; // <= endDate
    if (!Number.isNaN(startFrom?.getTime()) || !Number.isNaN(endTo?.getTime())) {
      where.AND = [];
      if (startFrom && !Number.isNaN(startFrom.getTime()))
        where.AND.push({ startDate: { gte: startFrom } });
      if (endTo && !Number.isNaN(endTo.getTime())) where.AND.push({ endDate: { lte: endTo } });
    }

    const [total, data] = await Promise.all([
      prisma.rental.count({ where }),
      prisma.rental.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
        include: {
          client: true,
          vehicle: true,
          tenant: { select: { id: true, name: true, domain: true } },
        },
      }),
    ]);

    res.json({
      data,
      pagination: { page, limit, total, pages: Math.ceil(total / limit) || 1 },
    });
  } catch (err) {
    console.error("GET /rentals error", err);
    res.status(500).json({ error: "internal_error" });
  }
});

/* ------------------------------ Obter por ID ------------------------------- */
router.get("/:id", async (req, res) => {
  try {
    const id = String(req.params.id);
    const rental = await prisma.rental.findUnique({
      where: { id },
      include: {
        client: true,
        vehicle: true,
        tenant: { select: { id: true, name: true, domain: true } },
      },
    });
    if (!rental) return res.status(404).json({ error: "rental_not_found" });
    res.json({ data: rental });
  } catch (e) {
    console.error("GET /rentals/:id error", e);
    res.status(500).json({ error: "internal_error" });
  }
});

/* --------------------------------- Criar ---------------------------------- */
router.post("/", async (req, res) => {
  try {
    const {
      tenantId,
      clientId,
      vehicleId,
      startDate,
      endDate,
      amount,
      status = "pending",
    } = req.body || {};

    const missing = [];
    for (const [k, v] of Object.entries({
      tenantId,
      clientId,
      vehicleId,
      startDate,
      endDate,
      amount,
    }))
      if (!v) missing.push(k);
    if (missing.length) return res.status(400).json({ error: "missing_fields", fields: missing });

    const sDate = coerceIsoDate(startDate);
    const eDate = coerceIsoDate(endDate);
    if (!sDate || !eDate) return res.status(400).json({ error: "invalid_date" });
    if (eDate <= sDate) return res.status(400).json({ error: "endDate_must_be_after_startDate" });

    // existência
    const [tenant, client, vehicle] = await Promise.all([
      prisma.tenant.findUnique({ where: { id: String(tenantId) } }),
      prisma.client.findUnique({ where: { id: String(clientId) } }),
      prisma.vehicle.findUnique({ where: { id: String(vehicleId) } }),
    ]);
    if (!tenant) return res.status(400).json({ error: "tenant_not_found" });
    if (!client) return res.status(400).json({ error: "client_not_found" });
    if (!vehicle) return res.status(400).json({ error: "vehicle_not_found" });

    // conflito (considera somente 'confirmed' conforme regra atual)
    const conflict = await findConflict({ vehicleId, start: sDate, end: eDate });
    if (conflict) {
      return res.status(409).json({ error: "vehicle_unavailable", conflictId: conflict.id });
    }

    const created = await prisma.rental.create({
      data: {
        tenantId: String(tenantId),
        clientId: String(clientId),
        vehicleId: String(vehicleId),
        startDate: sDate,
        endDate: eDate,
        status: String(status),
        amount: String(amount),
      },
    });

    res.status(201).json({ message: "rental_created", data: created });
  } catch (err) {
    console.error("POST /rentals error", err);
    res.status(500).json({ error: "internal_error" });
  }
});

/* --------------------------------- PATCH ---------------------------------- */
/* Correção: também checa conflito quando só muda o status para 'confirmed' */
router.patch("/:id", async (req, res) => {
  try {
    const id = String(req.params.id);
    const bodyStatus =
      typeof req.body?.status !== "undefined" ? String(req.body.status) : undefined;
    const bodyEnd =
      typeof req.body?.endDate !== "undefined" ? coerceIsoDate(req.body.endDate) : undefined;

    // carrega o atual uma vez só
    const current = await prisma.rental.findUnique({ where: { id } });
    if (!current) return res.status(404).json({ error: "rental_not_found" });

    const payload = {};
    let hasUpdate = false;

    // valida endDate se veio
    if (typeof req.body?.endDate !== "undefined") {
      if (!bodyEnd) return res.status(400).json({ error: "invalid_date" });
      if (bodyEnd <= current.startDate) {
        return res.status(400).json({ error: "endDate_must_be_after_startDate" });
      }
      payload.endDate = bodyEnd;
      hasUpdate = true;
    }

    // status se veio
    if (typeof req.body?.status !== "undefined") {
      payload.status = bodyStatus;
      hasUpdate = true;
    }

    if (!hasUpdate) return res.status(400).json({ error: "no_fields_to_update" });

    // estado final após aplicar o patch
    const finalStatus = typeof payload.status !== "undefined" ? payload.status : current.status;
    const finalEnd = typeof payload.endDate !== "undefined" ? payload.endDate : current.endDate;

    // regra: somente 'confirmed' bloqueia agenda
    if (finalStatus === "confirmed") {
      const conflict = await findConflict({
        vehicleId: current.vehicleId,
        start: current.startDate,
        end: finalEnd,
        excludeId: id,
      });
      if (conflict) {
        return res.status(409).json({ error: "vehicle_unavailable", conflictId: conflict.id });
      }
    }

    const updated = await prisma.rental.update({ where: { id }, data: payload });
    res.json({ message: "rental_updated", data: updated });
  } catch (e) {
    console.error("PATCH /rentals/:id error", e);
    if (e?.code === "P2025") return res.status(404).json({ error: "rental_not_found" });
    res.status(500).json({ error: "internal_error" });
  }
});

/* --------------------------------- DELETE --------------------------------- */
router.delete("/:id", async (req, res) => {
  try {
    const id = String(req.params.id);
    await prisma.rental.delete({ where: { id } });
    res.json({ message: "rental_deleted", id });
  } catch (e) {
    if (e?.code === "P2025") return res.status(404).json({ error: "rental_not_found" });
    console.error("DELETE /rentals/:id error", e);
    res.status(500).json({ error: "internal_error" });
  }
});

module.exports = router;

