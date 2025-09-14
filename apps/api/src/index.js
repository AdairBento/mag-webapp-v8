const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const fs = require("fs");
const path = require("path");
const crypto = require("crypto"); // <= necessário p/ randomUUID

const app = express();

// middlewares globais (ordem importa)
app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));

// logger simples de duração
app.use((req, res, next) => {
  const t0 = Date.now();
  res.on("finish", () => {
    console.log(`${req.method} ${req.originalUrl} -> ${res.statusCode} (${Date.now() - t0}ms)`);
  });
  next();
});

// Healthchecks
const startTs = Date.now();
app.get("/internal/health", (_, res) => res.json({ ok: true }));
app.get("/internal/health/extended", async (req, res) => {
  try {
    const { PrismaClient } = require("@prisma/client");
    const prisma = global.__prisma || new PrismaClient();
    if (!global.__prisma) global.__prisma = prisma;
    await prisma.$queryRaw`SELECT 1`;
    res.json({
      status: "ok",
      timestamp: new Date().toISOString(),
      uptime_ms: Date.now() - startTs,
      checks: { system: "ok", database: "ok" }
    });
  } catch (e) {
    res.status(500).json({
      status: "error",
      message: e?.message || String(e),
      checks: { system: "ok", database: "error" }
    });
  }
});

// Monta rota se o arquivo existir
function mount(routeRelPath, basePath) {
  const full = path.join(__dirname, routeRelPath);
  if (fs.existsSync(full)) {
    app.use(basePath, require(full));
    console.log(`Mounted ${basePath} -> ${routeRelPath}`);
  } else {
    console.warn(`WARN: route file not found: ${routeRelPath}`);
  }
}

// ── DIAGNÓSTICOS /api/v1/vehicles (ANTES do mount real!) ────────────────
app.get("/api/v1/vehicles/__ping", (req, res) => {
  return res.status(200).json({ ok: true, when: new Date().toISOString() });
});
app.get("/api/v1/vehicles/__stub", (req, res) => {
  return res.status(200).json({ data: [] });
});
app.post("/api/v1/vehicles/__stub", (req, res) => {
  const payload = req.body || {};
  return res.status(201).json({ data: { id: crypto.randomUUID(), ...payload } });
});

// ── mounts reais ────────────────────────────────────────────────────────
mount("./routes/rentals.routes.js", "/api/v1/rentals");
mount("./routes/maintenances.routes.js", "/api/v1/maintenances");
mount("./routes/tenants.routes.js", "/api/v1/tenants");
mount("./routes/clients.routes.js", "/api/v1/clients");
mount("./routes/vehicles.routes.js", "/api/v1/vehicles");

// middleware de erro (final da cadeia)
app.use((err, req, res, next) => {
  console.error("ERROR:", err);
  if (res.headersSent) return next(err);
  res.status(500).json({ error: "internal_error", message: err?.message ?? "unknown" });
});

const PORT = process.env.PORT || 3000;

// 404 JSON (catch-all depois das rotas)
app.use((_req, res) => res.status(404).json({ error: "route_not_found" }));

// subir servidor
app.listen(PORT, () => console.log(`API listening on http://localhost:${PORT}`));
