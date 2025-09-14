const express = require("express");
const { PrismaClient } = require("@prisma/client");
const router = express.Router();
const prisma = new PrismaClient();

router.get("/", async (req, res) => {
  const { limit = 50 } = req.query;
  const tenants = await prisma.tenant.findMany({ take: parseInt(limit,10), orderBy: { createdAt: "desc" } });
  res.json({ data: tenants });
});

router.post("/", async (req, res) => {
  const { id, name = "Dev Tenant", domain = "dev.local" } = req.body;
  try {
    const tenant = await prisma.tenant.upsert({
      where: { id: id || "dev" },
      update: { name, domain },
      create: { id: id || "dev", name, domain }
    });
    res.status(201).json({ data: tenant });
  } catch (e) {
    res.status(500).json({ error: "internal_error", message: e.message });
  }
});

module.exports = router;
