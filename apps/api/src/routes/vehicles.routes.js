// apps/api/src/routes/vehicles.routes.js
const express = require("express");
const crypto = require("crypto");
const { PrismaClient } = require("@prisma/client");
const { normalizeAmount } = require("../utils-amount");

console.log("🚗 vehicles.routes.js sendo carregado...");

// Prisma singleton (evita recriar a cada reload do nodemon)
let prisma;
try {
  console.log("🔧 Inicializando Prisma Client...");
  prisma = global.__prisma || new PrismaClient();
  if (!global.__prisma) global.__prisma = prisma;
  console.log("✅ Prisma Client inicializado com sucesso");
} catch (error) {
  console.error("❌ Erro ao inicializar Prisma:", error);
}

function requireNonEmpty(v, field) {
  if (v == null || String(v).trim() === "") {
    const e = new Error(`${field} é obrigatório`);
    e.status = 400;
    e.payload = { field };
    throw e;
  }
  return v;
}
function getPaging(req) {
  const page  = Math.max(1, parseInt(req.query.page  || "1", 10));
  const limit = Math.min(100, Math.max(1, parseInt(req.query.limit || "20", 10)));
  const skip  = (page - 1) * limit;
  return { page, limit, skip };
}
function sanitizePlate(s) {
  return String(s).trim().toUpperCase().replace(/\s+/g, "").replace(/-/g, "");
}
function getTenantId(req) {
  return req.header("x-tenant-id") || req.query.tenantId || (req.body && req.body.tenantId);
}

const r = express.Router();
console.log("🚗 Criando router vehicles...");

// middleware de log
r.use((req, _res, next) => {
  console.log(`🚗 [vehicles] Recebendo: ${req.method} ${req.originalUrl}`);
  next();
});

// DIAGNÓSTICO
r.get("/__ping", (_req, res) => res.status(200).json({ ok: true, when: new Date().toISOString() }));
r.get("/__stub", (_req, res) => res.status(200).json({ data: [] }));
r.post("/__stub", (req, res) => res.status(201).json({ data: { id: crypto.randomUUID(), ...(req.body || {}) } }));

// GET /api/v1/vehicles
r.get("/", async (req, res, next) => {
  console.log("🚗 GET vehicles iniciado");
  try {
    const tenantId = getTenantId(req);
    console.log("🔑 tenantId obtido:", tenantId);
    if (!tenantId) return res.status(400).json({ error: "bad_request", message: "tenantId é obrigatório" });

    const { page, limit, skip } = getPaging(req);
    const where = { tenantId };
    console.log("📄 Paginação:", { page, limit, skip });
    console.log("🔍 Where clause:", where);

    console.log("💾 Executando queries no banco...");
    const [items, total] = await Promise.all([
      prisma.vehicle.findMany({ where, skip, take: limit, orderBy: { createdAt: "desc" } }),
      prisma.vehicle.count({ where }),
    ]);

    console.log("✅ Queries concluídas:", { itemsCount: items.length, total });
    return res.json({ data: items, pagination: { page, limit, total, pages: Math.max(1, Math.ceil(total / limit)) } });
  } catch (e) {
    console.error("❌ Erro no GET vehicles:", e);
    return next(e);
  }
});

// POST /api/v1/vehicles
r.post("/", async (req, res, next) => {
  console.log("🚗 POST vehicles iniciado");
  try {
    const tenantId = getTenantId(req);
    const { plate, brand, model, year, dailyRate, status, color, fuelType, category } = req.body || {};
    console.log("📝 Dados recebidos:", { tenantId, plate, brand, model, year, dailyRate });

    requireNonEmpty(tenantId, "tenantId");
    requireNonEmpty(plate,    "plate");
    requireNonEmpty(brand,    "brand");
    requireNonEmpty(model,    "model");
    requireNonEmpty(year,     "year");

    // Fallback: se não mandou dailyRate, usa "120.00"
    const finalDailyRate = dailyRate != null ? normalizeAmount(dailyRate) : "120.00";
    console.log("💰 dailyRate final:", finalDailyRate);

    console.log("💾 Criando vehicle no banco...");
    const vehicle = await prisma.vehicle.create({
      data: {
        tenant:    { connect: { id: tenantId } },
        plate:     sanitizePlate(plate),
        brand:     String(brand).trim(),
        model:     String(model).trim(),
        year:      Number(year),
        color:     ((color    ?? "Prata") + "").trim() || "Prata",
        fuelType:  ((fuelType ?? "Flex")  + "").trim() || "Flex",
        category:  ((category ?? "Hatch") + "").trim() || "Hatch",
        dailyRate: finalDailyRate, // <- sempre definido
        status:    status || "available",
      },
    });

    console.log("✅ Vehicle criado:", vehicle.id);
    return res.status(201).json({ data: vehicle });
  } catch (e) {
    console.error("❌ Erro no POST vehicles:", e);
    if (e?.code === "P2002") {
      return res.status(409).json({ error: "conflict", message: "Registro já existe (constraint única)", meta: { target: e.meta?.target } });
    }
    return next(e);
  }
});

// 404 para subrotas não mapeadas
r.use((req, res) => {
  console.log("❓ 404 em vehicles:", req.originalUrl);
  res.status(404).json({ error: "not_found" });
});

console.log("✅ vehicles.routes.js configurado completamente");
module.exports = r;
