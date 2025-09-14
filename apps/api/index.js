// src/index.js (CommonJS + Prisma + SQLite/Postgres)
require("dotenv/config");
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();
const app = express();
const port = process.env.PORT || 3000;

app.use(helmet());
app.use(cors());
app.use(express.json());

/* -------------------------------------------------------------------------- */
/* Health                                                                     */
/* -------------------------------------------------------------------------- */
app.get("/internal/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

/* -------------------------------------------------------------------------- */
/* Utils                                                                      */
/* -------------------------------------------------------------------------- */
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
  // Conflito clássico: começa antes do fim E termina depois do início
  // Regra: só 'confirmed' bloqueia agenda
  return prisma.rental.findFirst({
    where: {
      vehicleId: String(vehicleId),
      startDate: { lt: end },
      endDate: { gt: start },
      status: { in: ["confirmed"] },
      ...(excludeId ? { NOT: { id: String(excludeId) } } : {}),
    },
    select: { id: true },
  });
}
function getTenantFromReq(req) {
  return (req.headers["x-tenant-id"] || req.query.tenantId || "").toString().trim();
}

/* -------------------------------------------------------------------------- */
/* Apoio: listar Clients / Vehicles (descobrir IDs)                           */
/* -------------------------------------------------------------------------- */
app.get("/api/v1/clients", async (req, res) => {
  try {
    const where = {};
    const tenantId = getTenantFromReq(req);
    if (tenantId) where.tenantId = tenantId;

    const data = await prisma.client.findMany({ where, orderBy: { name: "asc" } });
    res.json({ data });
  } catch (e) {
    console.error("GET /clients error", e);
    res.status(500).json({ error: "internal_error" });
  }
});

app.get("/api/v1/vehicles", async (req, res) => {
  try {
    const where = {};
    const tenantId = getTenantFromReq(req);
    if (tenantId) where.tenantId = tenantId;

    const data = await prisma.vehicle.findMany({ where, orderBy: { model: "asc" } });
    res.json({ data });
  } catch (e) {
    console.error("GET /vehicles error", e);
    res.status(500).json({ error: "internal_error" });
  }
});

/* -------------------------------------------------------------------------- */
/* Rentals                                                                    */
/* -------------------------------------------------------------------------- */
/**
 * GET /api/v1/rentals?page=1&limit=20&tenantId=...&status=confirmed&startFrom=YYYY-MM-DD&endTo=YYYY-MM-DD
 * Lista rentals com filtros e paginação; inclui client, vehicle e um resumo do tenant.
 */
app.get("/api/v1/rentals", async (req, res) => {
  try {
    const page = parsePositiveInt(req.query.page, 1);
    const limit = parsePositiveInt(req.query.limit, 20);
    const skip = (page - 1) * limit;

    const where = {};
    const tenantId = getTenantFromReq(req);
    if (tenantId) where.tenantId = tenantId;

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
      filters: {
        status: req.query.status ?? null,
        startFrom: req.query.startFrom ?? null,
        endTo: req.query.endTo ?? null,
      },
    });
  } catch (err) {
    console.error("GET /rentals error", err);
    res.status(500).json({ error: "internal_error" });
  }
});

/**
 * GET /api/v1/rentals/:id
 * Retorna um rental com include de client, vehicle e tenant.
 */
app.get("/api/v1/rentals/:id", async (req, res) => {
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

/**
 * POST /api/v1/rentals
 * Body mínimo:
 * {
 *   "tenantId": "uuid-tenant",  // será sobrescrito pelo header x-tenant-id se vier
 *   "clientId": "uuid-client",
 *   "vehicleId": "uuid-vehicle",
 *   "startDate": "2025-09-08T12:00:00.000Z",
 *   "endDate":   "2025-09-10T12:00:00.000Z",
 *   "amount": "350.00",
 *   "status": "pending" | "confirmed" | "completed" | "canceled"  (opcional, default: pending)
 * }
 */
app.post("/api/v1/rentals", async (req, res) => {
  try {
    const headerTenant = getTenantFromReq(req);
    const {
      tenantId: bodyTenantId,
      clientId,
      vehicleId,
      startDate,
      endDate,
      amount,
      status = "pending",
    } = req.body || {};

    const tenantId = (headerTenant || bodyTenantId || "").toString().trim();

    // Validação básica
    const missing = [];
    for (const [k, v] of Object.entries({
      tenantId,
      clientId,
      vehicleId,
      startDate,
      endDate,
      amount,
    })) {
      if (!v) missing.push(k);
    }
    if (missing.length) {
      return res.status(400).json({ error: "missing_fields", fields: missing });
    }

    const sDate = coerceIsoDate(startDate);
    const eDate = coerceIsoDate(endDate);
    if (!sDate || !eDate) return res.status(400).json({ error: "invalid_date" });
    if (eDate <= sDate) {
      return res.status(400).json({ error: "endDate_must_be_after_startDate" });
    }

    // Verificações simples de existência
    const [tenant, client, vehicle] = await Promise.all([
      prisma.tenant.findUnique({ where: { id: String(tenantId) } }),
      prisma.client.findUnique({ where: { id: String(clientId) } }),
      prisma.vehicle.findUnique({ where: { id: String(vehicleId) } }),
    ]);
    if (!tenant) return res.status(400).json({ error: "tenant_not_found" });
    if (!client) return res.status(400).json({ error: "client_not_found" });
    if (!vehicle) return res.status(400).json({ error: "vehicle_not_found" });

    // Conflito: somente bloqueia se for criar como 'confirmed'
    if (String(status) === "confirmed") {
      const conflict = await findConflict({ vehicleId, start: sDate, end: eDate });
      if (conflict) {
        return res.status(409).json({ error: "vehicle_unavailable", conflictId: conflict.id });
      }
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

/**
 * PATCH /api/v1/rentals/:id
 * Campos aceitos: { status?, endDate? }
 * - endDate deve ser data válida e > startDate atual
 * - se status final ficar "confirmed", valida conflito
 * - requer header x-tenant-id correspondente ao registro
 */
app.patch("/api/v1/rentals/:id", async (req, res) => {
  try {
    const id = String(req.params.id);
    const tenantIdHeader = (req.headers["x-tenant-id"] || "").toString().trim();
    if (!tenantIdHeader) {
      return res.status(400).json({ error: "missing_tenant_header", header: "x-tenant-id" });
    }

    // carrega o atual uma vez só
    const current = await prisma.rental.findUnique({ where: { id } });
    if (!current) return res.status(404).json({ error: "rental_not_found" });
    if (String(current.tenantId) !== tenantIdHeader) {
      return res.status(403).json({ error: "forbidden" });
    }

    const payload = {};
    let hasUpdate = false;

    // status
    if (typeof req.body?.status !== "undefined") {
      payload.status = String(req.body.status);
      hasUpdate = true;
    }

    // endDate
    if (typeof req.body?.endDate !== "undefined") {
      const newEnd = coerceIsoDate(req.body.endDate);
      if (!newEnd) return res.status(400).json({ error: "invalid_date" });
      if (newEnd <= current.startDate) {
        return res.status(400).json({ error: "endDate_must_be_after_startDate" });
      }
      payload.endDate = newEnd;
      hasUpdate = true;
    }

    if (!hasUpdate) return res.status(400).json({ error: "no_fields_to_update" });

    // Estado final simulado
    const finalStatus =
      typeof payload.status !== "undefined" ? payload.status : current.status;
    const finalEnd =
      typeof payload.endDate !== "undefined" ? payload.endDate : current.endDate;

    // Se ficar confirmed, validar conflito
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
    if (e?.code === "P2025") {
      return res.status(404).json({ error: "rental_not_found" });
    }
    res.status(500).json({ error: "internal_error" });
  }
});

/**
 * DELETE /api/v1/rentals/:id
 * Requer header x-tenant-id que corresponda ao registro.
 */
app.delete("/api/v1/rentals/:id", async (req, res) => {
  try {
    const id = String(req.params.id);
    const tenantIdHeader = (req.headers["x-tenant-id"] || "").toString().trim();
    if (!tenantIdHeader) {
      return res.status(400).json({ error: "missing_tenant_header", header: "x-tenant-id" });
    }

    const current = await prisma.rental.findUnique({ where: { id } });
    if (!current) return res.status(404).json({ error: "rental_not_found" });
    if (String(current.tenantId) !== tenantIdHeader) {
      return res.status(403).json({ error: "forbidden" });
    }

    await prisma.rental.delete({ where: { id } });
    res.json({ message: "rental_deleted", id });
  } catch (e) {
    if (e?.code === "P2025") return res.status(404).json({ error: "rental_not_found" });
    console.error("DELETE /rentals/:id error", e);
    res.status(500).json({ error: "internal_error" });
  }
});

/* -------------------------------------------------------------------------- */
/* Seeds                                                                      */
/* -------------------------------------------------------------------------- */
/**
 * POST /internal/seed
 * Idempotente: reusa Tenant/Client/Vehicle se já existirem (pelas chaves únicas).
 */
app.post("/internal/seed", async (req, res) => {
  try {
    // 1) Tenant por domain
    let tenant = await prisma.tenant.findUnique({
      where: { domain: "demo.local" },
    });
    if (!tenant) {
      tenant = await prisma.tenant.create({
        data: { name: "Demo Tenant", domain: "demo.local", settings: null },
      });
    }

    // 2) Client por (email, tenantId)
    const email = "cliente.demo@mail.local"; // fixo para idempotência
    let client = await prisma.client.findUnique({
      where: { email_tenantId: { email, tenantId: tenant.id } },
    });
    if (!client) {
      client = await prisma.client.create({
        data: {
          name: "Cliente Demo",
          email,
          phone: "5511999998888",
          document: "00000000000",
          address: "Rua Teste, 123",
          tenantId: tenant.id,
        },
      });
    }

    // 3) Vehicle por (plate, tenantId)
    const plate = "ABC8736"; // fixo para idempotência
    let vehicle = await prisma.vehicle.findUnique({
      where: { plate_tenantId: { plate, tenantId: tenant.id } },
    });
    if (!vehicle) {
      vehicle = await prisma.vehicle.create({
        data: {
          model: "Onix",
          brand: "Chevrolet",
          year: 2022,
          plate,
          color: "Prata",
          fuelType: "Flex",
          category: "Hatch",
          dailyRate: "120.00",
          status: "available",
          tenantId: tenant.id,
        },
      });
    }

    res.status(201).json({ tenant, client, vehicle });
  } catch (e) {
    console.error("SEED error", e);
    res.status(500).json({ error: "seed_failed" });
  }
});

/**
 * POST /api/v1/tenants/:id/rentals/seed?qty=5
 * Cria N rentals de exemplo (requer já existir ao menos 1 client e 1 vehicle no tenant).
 */
app.post("/api/v1/tenants/:id/rentals/seed", async (req, res) => {
  try {
    const tenantId = String(req.params.id);
    const qty = Number.isFinite(Number(req.query.qty)) ? Number(req.query.qty) : 3;

    const tenant = await prisma.tenant.findUnique({ where: { id: tenantId } });
    if (!tenant) return res.status(404).json({ error: "tenant_not_found" });

    const [client] = await prisma.client.findMany({ where: { tenantId }, take: 1 });
    const [vehicle] = await prisma.vehicle.findMany({ where: { tenantId }, take: 1 });
    if (!client || !vehicle) {
      return res.status(400).json({ error: "seed_client_or_vehicle_missing" });
    }

    const now = new Date();
    const created = [];

    for (let i = 0; i < qty; i++) {
      const start = new Date(now.getTime() + i * 24 * 60 * 60 * 1000);
      const end = new Date(start.getTime() + 2 * 24 * 60 * 60 * 1000);

      const rental = await prisma.rental.create({
        data: {
          tenantId,
          clientId: client.id,
          vehicleId: vehicle.id,
          startDate: start,
          endDate: end,
          status: "pending",
          amount: "240.00",
        },
      });
      created.push(rental);
    }

    res.status(201).json({ created: created.length, rentals: created });
  } catch (e) {
    console.error("rentals seed error", e);
    res.status(500).json({ error: "rentals_seed_failed" });
  }
});

/* -------------------------------------------------------------------------- */
/* 404                                                                        */
/* -------------------------------------------------------------------------- */
app.use("*", (req, res) => {
  res.status(404).json({ error: "route_not_found", path: req.originalUrl });
});

/* -------------------------------------------------------------------------- */
/* Boot                                                                       */
/* -------------------------------------------------------------------------- */
app.listen(port, () => {
  console.log(`API rodando em http://localhost:${port}`);
  console.log(`Health: http://localhost:${port}/internal/health`);
  console.log(`Rentals: http://localhost:${port}/api/v1/rentals`);
});

// Fechamento gracioso do Prisma ao encerrar
process.on("SIGINT", async () => {
  await prisma.$disconnect();
  process.exit(0);
});
process.on("SIGTERM", async () => {
  await prisma.$disconnect();
  process.exit(0);
});
