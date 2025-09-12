const createHealthHandler = require("./health-extended");
function coerceIsoDate(input) {
  if (!input) return null;
  const raw = String(input).trim();
  const iso = /^\d{4}-\d{2}-\d{2}$/.test(raw) ? (raw + "T00:00:00.000Z") : raw;
  const d = new Date(iso);
  if (isNaN(d.getTime())) return null;
  return new Date(d.toISOString()); // normaliza para UTC
}
// src/index.js
// MAG API â€” Express + Prisma (alias availability, paginaÃ§Ã£o, CORS/Helmet, filtros e POSTs + cÃ¡lculo de amount)

require("dotenv/config");
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const { PrismaClient } = require("@prisma/client");
const { addTraceId, httpLogger } = require("./middleware-logger");
const { errorHandler, ApiError } = require("./middleware-errors");
const { normalizeAvailabilityParams } = require("./availability-alias");
const { RENTAL_STATUSES, isValidStatus, isBlockingStatus } = require("./utils-status");
const { normalizeAmount } = require("./utils-amount");

const prisma = new PrismaClient();
const app = express();
const PORT = Number(process.env.PORT) || 3000;

/* ===================== MIDDLEWARES ===================== */
app.use(helmet());
app.use(cors()); // ajuste: cors({ origin: ["http://localhost:5173"] })
app.use(express.json());
app.use("/internal", require("./ui/internal"));
app.use(addTraceId);
app.use(httpLogger);

/* ===================== HELPERS ===================== */
function getPaging(req) {
  const page = Math.max(1, parseInt(req.query.page || "1", 10));
  const limit = Math.min(100, Math.max(1, parseInt(req.query.limit || "20", 10)));
  const skip = (page - 1) * limit;
  return { page, limit, skip };
}

function requireNonEmpty(value, field) {
  if (value === undefined || value === null || String(value).trim() === "") {
    throw new ApiError("bad_request", `${field} Ã© obrigatÃ³rio`, 400, { field });
  }
  return value;
}

function isIsoDate(s) {
  return typeof s === "string" && /^\d{4}-\d{2}-\d{2}(T.*)?$/.test(s);
}

function requireIsoDate(s, field) {
  if (!isIsoDate(s)) {
    throw new ApiError("bad_request", `${field} invÃ¡lido (use YYYY-MM-DD)`, 400, { [field]: s });
  }
  return s;
}

function toDate(s) {
  const d = new Date(s);
  if (isNaN(d.getTime())) throw new ApiError("bad_request", `data invÃ¡lida`, 400, { value: s });
  return d;
}

function diffDaysUTC(a, b) {
  const MS = 24 * 60 * 60 * 1000;
  const start = Date.UTC(a.getUTCFullYear(), a.getUTCMonth(), a.getUTCDate());
  const end = Date.UTC(b.getUTCFullYear(), b.getUTCMonth(), b.getUTCDate());
  return Math.round((end - start) / MS);
}

/* ===================== ROOT ===================== */
app.get("/", (_req, res) => {
  res.json({ name: "MAG API", version: "1.0.0", status: "ok" });
});

/* ===================== INTERNAL ===================== */
app.get("/internal/health", (_req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});
app.get("/internal/health/extended", createHealthHandler({ prisma }));

app.post("/internal/seed", async (_req, res, next) => {
  try {
    const tenant = await prisma.tenant.upsert({
      where: { id: "022d0c59-4363-4993-a485-9adf29719824" },
      update: {},
      create: {
        id: "022d0c59-4363-4993-a485-9adf29719824",
        name: "Demo Tenant",
        domain: "demo.local",
      },
    });

    const client = await prisma.client.upsert({
      where: { id: "3d2f8a39-3e5f-4a27-96e3-80fc02502789" },
      update: {},
      create: {
        id: "3d2f8a39-3e5f-4a27-96e3-80fc02502789",
        name: "Cliente Demo",
        email: "cliente.demo@mail.local",
        phone: "5511999998888",
        document: "00000000000",
        address: "Rua Teste, 123",
        tenant: { connect: { id: tenant.id } },
      },
    });

    const vehicle = await prisma.vehicle.upsert({
      where: { id: "d0e03f05-50aa-45fe-b049-de1bff02ac85" },
      update: {},
      create: {
        id: "d0e03f05-50aa-45fe-b049-de1bff02ac85",
        model: "Onix",
        brand: "Chevrolet",
        year: 2022,
        plate: "ABC8736",
        color: "Prata",
        fuelType: "Flex",
        category: "Hatch",
        dailyRate: "120.00",
        status: "available",
        tenant: { connect: { id: tenant.id } },
      },
    });

    res.json({ tenant, client, vehicle });
  } catch (err) {
    next(err);
  }
});

/* ===================== API v1 ===================== */
// Availability (contrato simples) + alias raiz
const availabilityHandler = async (req, res, next) => {
  try {
    res.json({
      data: [],
      pagination: { page: 1, limit: 20, total: 0, pages: 1 },
      meta: { mode: req.query.mode || "available", blockedVehicleCount: 0 },
    });
  } catch (err) {
    next(err);
  }
};

app.get("/api/v1/availability", normalizeAvailabilityParams, async (req, res, next) => {
  try {
    const tenantId = requireNonEmpty(req.query.tenantId, "tenantId");

    const { startDate, endDate } = req.query;
    const start =
      req.availabilityWindow && req.availabilityWindow.start
        ? req.availabilityWindow.start
        : new Date(startDate);
    const end =
      req.availabilityWindow && req.availabilityWindow.end
        ? req.availabilityWindow.end
        : new Date(endDate);

    const { page, limit, skip } = getPaging(req);

    // rentals que bloqueiam (ajuste se tiver mais statuses)
    const blockingStatuses = ["confirmed"];

    // Overlap: !(r.end <= start || r.start >= end)
    const overlapping = await prisma.rental.findMany({
      where: {
        tenantId,
        status: { in: blockingStatuses },
        NOT: [{ endDate: { lte: start } }, { startDate: { gte: end } }],
      },
      select: { vehicleId: true },
    });

    const blockedIds = [...new Set(overlapping.map((r) => r.vehicleId))];

    // DisponÃ­veis = available - bloqueados no range
    const mode = String(req.query.mode || "available").toLowerCase();
    let vehicleWhere;
    if (mode === "blocked") {
      vehicleWhere = {
        tenantId,
        ...(blockedIds.length ? { id: { in: blockedIds } } : { id: { in: [] } }),
      };
    } else {
      vehicleWhere = {
        tenantId,
        status: "available",
        ...(blockedIds.length ? { id: { notIn: blockedIds } } : {}),
      };
    }

    const [data, total] = await Promise.all([
      prisma.vehicle.findMany({
        where: vehicleWhere,
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
      }),
      prisma.vehicle.count({ where: vehicleWhere }),
    ]);

    res.json({
      data,
      pagination: { page, limit, total, pages: Math.max(1, Math.ceil(total / limit)) },
      meta: {
        mode: req.query.mode || "available",
        blockedVehicleCount: blockedIds.length,
        window: { startDate: req.query.startDate, endDate: req.query.endDate },
      },
    });
  } catch (err) {
    next(err);
  }
});

app.get("/availability", normalizeAvailabilityParams, availabilityHandler);

// Clients (GET com paginaÃ§Ã£o)
app.get("/api/v1/clients", async (req, res, next) => {
  try {
    const { tenantId } = req.query;
    if (!tenantId)
      return res.status(400).json({ error: "bad_request", message: "tenantId Ã© obrigatÃ³rio" });

    const { page, limit, skip } = getPaging(req);
    const [items, total] = await Promise.all([
      prisma.client.findMany({ where: { tenantId }, skip, take: limit }),
      prisma.client.count({ where: { tenantId } }),
    ]);
    res.json({
      data: items,
      pagination: { page, limit, total, pages: Math.max(1, Math.ceil(total / limit)) },
    });
  } catch (err) {
    next(err);
  }
});

// Vehicles (GET com paginaÃ§Ã£o)
app.get("/api/v1/vehicles", async (req, res, next) => {
  try {
    const { tenantId } = req.query;
    if (!tenantId)
      return res.status(400).json({ error: "bad_request", message: "tenantId Ã© obrigatÃ³rio" });

    const { page, limit, skip } = getPaging(req);
    const [items, total] = await Promise.all([
      prisma.vehicle.findMany({ where: { tenantId }, skip, take: limit }),
      prisma.vehicle.count({ where: { tenantId } }),
    ]);
    res.json({
      data: items,
      pagination: { page, limit, total, pages: Math.max(1, Math.ceil(total / limit)) },
    });
  } catch (err) {
    next(err);
  }
});

// Rentals (GET com paginaÃ§Ã£o + filtros opcionais)
app.get("/api/v1/rentals", async (req, res, next) => {
  try {
    const { tenantId, status, startFrom, endTo } = req.query;
    if (!tenantId)
      return res.status(400).json({ error: "bad_request", message: "tenantId Ã© obrigatÃ³rio" });

    if (status && !isValidStatus(status)) {
      return res.status(400).json({
        error: "bad_request",
        message: "status invÃ¡lido",
        details: { allowed: Object.values(RENTAL_STATUSES) },
      });
    }
    if ((startFrom && !isIsoDate(startFrom)) || (endTo && !isIsoDate(endTo))) {
      return res.status(400).json({
        error: "bad_request",
        message: "datas invÃ¡lidas (use YYYY-MM-DD)",
        details: { startFrom, endTo },
      });
    }

    const where = { tenantId };
    if (status) where.status = status;
    if (startFrom)
      where.startDate = Object.assign(where.startDate ?? {}, { gte: new Date(startFrom) });
    if (endTo) where.endDate = Object.assign(where.endDate ?? {}, { lte: new Date(endTo) });

    const { page, limit, skip } = getPaging(req);
    const [items, total] = await Promise.all([
      prisma.rental.findMany({
        where,
        include: {
          client: true,
          vehicle: true,
          tenant: { select: { id: true, name: true, domain: true } },
        },
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
      }),
      prisma.rental.count({ where }),
    ]);

    res.json({
      data: items,
      pagination: { page, limit, total, pages: Math.max(1, Math.ceil(total / limit)) },
      filters: { status: status || null, startFrom: startFrom || null, endTo: endTo || null },
    });
  } catch (err) {
    next(err);
  }
});

// Rentals (GET por id)
app.get("/api/v1/rentals/:id", async (req, res, next) => {
  try {
    const rental = await prisma.rental.findUnique({ where: { id: req.params.id } });
    if (!rental) return res.status(404).json({ error: "not_found", message: "not_found" });
    res.json({ data: rental });
  } catch (err) {
    next(err);
  }
});

/* ===================== CREATES (POST) ===================== */
// POST /api/v1/clients
app.post("/api/v1/clients", async (req, res, next) => {
  try {
    const { tenantId, name, email, phone, document, address } = req.body || {};
    requireNonEmpty(tenantId, "tenantId");
    requireNonEmpty(name, "name");

    const address_ = ((address ?? "") + "").trim(); // nunca null

    const client = await prisma.client.create({
      data: {
        tenant: { connect: { id: tenantId } },
        name,
        email: email ?? null,
        phone: phone ?? null,
        document: document ?? null,
        address: address_,
      },
    });

    res.status(201).json({ data: client });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/vehicles
app.post("/api/v1/vehicles", async (req, res, next) => {
  try {
    const { tenantId, plate, brand, model, year, dailyRate, status, color, fuelType, category } =
      req.body || {};
    requireNonEmpty(tenantId, "tenantId");
    requireNonEmpty(plate, "plate");
    requireNonEmpty(brand, "brand");
    requireNonEmpty(model, "model");
    requireNonEmpty(year, "year");

    const normalizedRate =
      dailyRate !== undefined && dailyRate !== null ? normalizeAmount(dailyRate) : null;

    const color_ = ((color ?? "Prata") + "").trim() || "Prata";
    const fuelType_ = ((fuelType ?? "Flex") + "").trim() || "Flex";
    const category_ = ((category ?? "Hatch") + "").trim() || "Hatch";

    const vehicle = await prisma.vehicle.create({
      data: {
        tenant: { connect: { id: tenantId } },
        model,
        brand,
        year: Number(year),
        plate,
        color: color_,
        fuelType: fuelType_,
        category: category_,
        dailyRate: normalizedRate,
        status: status || "available",
      },
    });

    res.status(201).json({ data: vehicle });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/rentals
// Campos: tenantId, clientId, vehicleId, startDate, endDate, status (opcional; default 'confirmed'), amount (opcional)
app.post("/api/v1/rentals", async (req, res, next) => {
  try {
    const { tenantId, clientId, vehicleId, startDate, endDate, status, amount } = req.body;

    requireNonEmpty(tenantId, "tenantId");
    requireNonEmpty(clientId, "clientId");
    requireNonEmpty(vehicleId, "vehicleId");
    requireIsoDate(startDate, "startDate");
    requireIsoDate(endDate, "endDate");

    const start = toDate(startDate);
    const end = toDate(endDate);
    if (end <= start) {
      throw new ApiError("bad_request", "endDate deve ser maior que startDate", 400, {
        startDate,
        endDate,
      });
    }

    const rentalStatus = status || RENTAL_STATUSES.CONFIRMED;
    if (!isValidStatus(rentalStatus)) {
      throw new ApiError("bad_request", "status invÃ¡lido", 400, {
        allowed: Object.values(RENTAL_STATUSES),
      });
    }

    // valida entidades
    const [tenant, client, vehicle] = await Promise.all([
      prisma.tenant.findUnique({ where: { id: tenantId } }),
      prisma.client.findUnique({ where: { id: clientId } }),
      prisma.vehicle.findUnique({ where: { id: vehicleId } }),
    ]);
    if (!tenant) throw new ApiError("not_found", "tenant nÃ£o encontrado", 404, { tenantId });
    if (!client) throw new ApiError("not_found", "client nÃ£o encontrado", 404, { clientId });
    if (!vehicle) throw new ApiError("not_found", "vehicle nÃ£o encontrado", 404, { vehicleId });

    // conflito somente para statuses bloqueantes
    if (isBlockingStatus(rentalStatus)) {
      const conflicting = await prisma.rental.findFirst({
        where: {
          tenantId,
          vehicleId,
          status: RENTAL_STATUSES.CONFIRMED,
          NOT: [{ endDate: { lte: start } }, { startDate: { gte: end } }],
        },
      });
      if (conflicting) {
        throw new ApiError("conflict", "Conflito de agenda para este veÃ­culo", 409, {
          vehicleId,
          requested: { startDate, endDate },
          conflictWith: {
            id: conflicting.id,
            startDate: conflicting.startDate,
            endDate: conflicting.endDate,
            status: conflicting.status,
          },
        });
      }
    }

    // amount: usa o enviado OU calcula (diÃ¡rias Ã— dailyRate)
    let finalAmount = amount;
    if (finalAmount === undefined || finalAmount === null || String(finalAmount).trim() === "") {
      const days = Math.max(1, diffDaysUTC(start, end)); // garante pelo menos 1 diÃ¡ria
      const rate = vehicle.dailyRate ? parseFloat(vehicle.dailyRate) : 0;
      finalAmount = normalizeAmount(days * rate);
    } else {
      finalAmount = normalizeAmount(finalAmount);
    }

    const rental = await prisma.rental.create({
      data: {
        tenantId,
        clientId,
        vehicleId,
        startDate: start,
        endDate: end,
        status: rentalStatus,
        amount: finalAmount,
      },
    });

    res.status(201).json({ data: rental });
  } catch (err) {
    next(err);
  }
});

/* ===================== 404 & ERROR ===================== */
app.use((req, res) => {
  res.status(404).json({ error: "route_not_found", path: req.path });
});
app.use(errorHandler);

/* ===================== START ===================== */
app.use('/api/v1', require('./routes/public-seed'));

/**
 * PATCH /api/v1/rentals/:id
 * Atualiza status ou endDate de uma rental
 */
app.patch("/api/v1/rentals/:id", async (req, res) => {
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

    const payload = {};
    let hasUpdate = false;

    // Status permitido
    if (typeof req.body?.status !== "undefined") {
      const status = String(req.body.status);
      const ALLOWED = new Set(["pending","confirmed","canceled","active","completed"]);
      if (!ALLOWED.has(status)) {
        return res.status(400).json({ error: "invalid_status", allowed: Array.from(ALLOWED) });
      }
      payload.status = status;
      hasUpdate = true;
    }

    // Atualizar endDate
    if (typeof req.body?.endDate !== "undefined") {
      const newEnd = coerceIsoDate(req.body.endDate);
      if (!(newEnd instanceof Date) || Number.isNaN(+newEnd)) {
        return res.status(400).json({ error: "invalid_date" });
      }
      if (newEnd <= current.startDate) {
        return res.status(400).json({ error: "endDate_must_be_after_startDate" });
      }
      payload.endDate = newEnd;
      hasUpdate = true;
    }

    if (!hasUpdate) return res.status(400).json({ error: "no_fields_to_update" });

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
app.get("/internal/routes", (req, res) => {
  const stack = (app._router && app._router.stack) ? app._router.stack : [];
  const routes = [];
  for (const layer of stack) {
    if (layer.route && layer.route.path) {
      const methods = Object.keys(layer.route.methods).filter(k => layer.route.methods[k]);
      routes.push({ path: layer.route.path, methods });
    } else if (layer.name === "router" && layer.handle && layer.handle.stack) {
      for (const r of layer.handle.stack) {
        if (r.route && r.route.path) {
          const methods = Object.keys(r.route.methods).filter(k => r.route.methods[k]);
          routes.push({ path: r.route.path, methods, base: layer.regexp && layer.regexp.toString() });
        }
      }
    }
  }
  res.json({ routes });
});

app.listen(PORT, () => {
  console.log(`API rodando em http://localhost:${PORT}`);
  console.log(`Health:    http://localhost:${PORT}/internal/health`);
  console.log(`Extended:  http://localhost:${PORT}/internal/health/extended`);
  console.log(`Seed:     POST http://localhost:${PORT}/internal/seed`);
  console.log(`Clients:  http://localhost:${PORT}/api/v1/clients?tenantId=...&page=1&limit=20`);
  console.log(`Vehicles: http://localhost:${PORT}/api/v1/vehicles?tenantId=...&page=1&limit=20`);
  console.log(`Rentals:  http://localhost:${PORT}/api/v1/rentals?tenantId=...&page=1&limit=20`);
  console.log(
    `Avail.:   http://localhost:${PORT}/api/v1/availability?from=YYYY-MM-DD&to=YYYY-MM-DD`,
  );
});

// teste husky
// teste husky
// teste husky
// teste husky
// test hook
// test lint-staged





// teste husky 2




/** __PROBE__ — deve responder 200 se ESTE arquivo for o que está rodando */
try {
  if (typeof app?.get === "function") {
    app.get("/__probe", (req, res) => res.json({ ok: true, file: __filename }));
    console.log("[BOOT] __PROBE__ registrado em /__probe from", __filename);
  }
} catch (e) {
  console.error("Falha ao registrar __PROBE__", e);
}
/** __PROBE__ — responde 200 para confirmar o arquivo em execução */
try {
  if (typeof app?.get === "function") {
    app.get("/__probe", (req, res) => res.json({ ok: true, file: __filename }));
    console.log("[BOOT] __PROBE__ registrado em /__probe from", __filename);
  }
} catch (e) {
  console.error("Falha ao registrar __PROBE__", e);
}
/** __PROBE__ — responde 200 para confirmar o arquivo em execução */
try {
  if (typeof app?.get === "function") {
    app.get("/__probe", (req, res) => res.json({ ok: true, file: __filename }));
    console.log("[BOOT] __PROBE__ registrado em /__probe from", __filename);
  }
} catch (e) {
  console.error("Falha ao registrar __PROBE__", e);
}
// teste husky 2
