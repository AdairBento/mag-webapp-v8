const express = require("express");
const router  = express.Router();
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// GET /api/v1/clients
router.get("/", async (req, res) => {
  try {
    const { tenantId, email, limit = 100 } = req.query;
    const data = await prisma.client.findMany({
      where: {
        tenantId: tenantId ? String(tenantId) : undefined,
        email:    email ? String(email) : undefined,
      },
      take: parseInt(limit, 10),
      orderBy: { createdAt: "desc" },
    });
    res.json({ data });
  } catch (e) {
    console.error("[clients.get] error:", e);
    res.status(500).json({ error:"internal_error", message:e.message });
  }
});

// POST /api/v1/clients
router.post("/", async (req, res) => {
  const { tenantId: tId, name, email } = req.body;
  const id = tId || req.get("x-tenant-id") || req.query.tenantId;

  // Fallbacks para esquemas com NOT NULL
  const phone    = (req.body.phone ?? "000000000");
  const document = (req.body.document ?? "DOC-TESTE");
  const address  = (req.body.address ?? "N/D");

  if (!id)    return res.status(400).json({ error:"bad_request", message:"tenantId required" });
  if (!name)  return res.status(400).json({ error:"bad_request", message:"name required" });
  if (!email) return res.status(400).json({ error:"bad_request", message:"email required" });

  try {
    const data = {
      tenant:   { connect: { id: String(id) } },
      name:     String(name),
      email:    String(email).toLowerCase(),
      phone,
      document,
      address
    };
    const client = await prisma.client.create({ data });
    res.status(201).json({ data: client });
  } catch (e) {
    console.error("[clients.post] Prisma error:", {
      code: e.code, message: e.message, meta: e.meta, stack: e.stack
    });
    const code = e.code === "P2002" ? 409 : (e.code === "P2003" ? 400 : 500);
    const err  = e.code === "P2002" ? "conflict" : (e.code === "P2003" ? "constraint" : "internal_error");
    res.status(code).json({ error: err, message: e.message, code: e.code, meta: e.meta });
  }
});

module.exports = router;
