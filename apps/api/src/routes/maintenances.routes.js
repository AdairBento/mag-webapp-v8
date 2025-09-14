const express = require("express");
const router  = express.Router();
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// GET /api/v1/maintenances
router.get("/", async (req, res) => {
  try {
    const { tenantId, vehicleId, status, limit = 100 } = req.query;
    const data = await prisma.maintenance.findMany({
      where: {
        tenantId:  tenantId ? String(tenantId) : undefined,
        vehicleId: vehicleId ? String(vehicleId) : undefined,
        status:    status || undefined
      },
      take: parseInt(limit, 10),
      orderBy: { startDate: "desc" },
    });
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error:"internal_error", message:e.message });
  }
});

// POST /api/v1/maintenances
router.post("/", async (req, res) => {
  const id = req.body.tenantId || req.get("x-tenant-id") || req.query.tenantId;
  const { vehicleId, description, startDate, endDate, status } = req.body;
  if (!id)          return res.status(400).json({ error:"bad_request", message:"tenantId required" });
  if (!vehicleId)   return res.status(400).json({ error:"bad_request", message:"vehicleId required" });
  if (!description) return res.status(400).json({ error:"bad_request", message:"description required" });
  if (!startDate)   return res.status(400).json({ error:"bad_request", message:"startDate required" });
  try {
    const data = {
      tenant:      { connect: { id: String(id) } },
      vehicle:     { connect: { id: String(vehicleId) } },
      description: String(description),
      startDate:   new Date(startDate),
      endDate:     endDate ? new Date(endDate) : null,
      status:      status ?? "scheduled"
    };
    const created = await prisma.maintenance.create({ data });
    res.status(201).json({ data: created });
  } catch (e) {
    res.status(400).json({ error:"bad_request", message:e.message });
  }
});

module.exports = router;
