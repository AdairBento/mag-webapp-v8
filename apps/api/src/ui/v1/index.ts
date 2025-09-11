// @ts-nocheck
export {};
const router = require("express").Router();
const prisma = require("../../prisma");

// Sub-rotas
router.use("/rentals", require("./rentals"));

// Apoio: listar clients/vehicles (para descobrir IDs)
router.get("/clients", async (req, res) => {
  try {
    const where = {};
    if (req.query.tenantId) where.tenantId = String(req.query.tenantId);
    const data = await prisma.client.findMany({ where, orderBy: { name: "asc" } });
    res.json({ data });
  } catch (e) {
    console.error("GET /clients error", e);
    res.status(500).json({ error: "internal_error" });
  }
});

router.get("/vehicles", async (req, res) => {
  try {
    const where = {};
    if (req.query.tenantId) where.tenantId = String(req.query.tenantId);
    const data = await prisma.vehicle.findMany({ where, orderBy: { model: "asc" } });
    res.json({ data });
  } catch (e) {
    console.error("GET /vehicles error", e);
    res.status(500).json({ error: "internal_error" });
  }
});

module.exports = router;

