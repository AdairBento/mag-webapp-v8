const express = require("express");
const prisma = require("../db");
const router = express.Router();

function parsePositiveInt(v, def) {
  const n = parseInt(v, 10);
  return Number.isFinite(n) && n > 0 ? n : def;
}

router.get("/clients", async (req, res, next) => {
  try {
    const tenantId = req.tenantId;
    const page = parsePositiveInt(req.query.page, 1);
    const limit = Math.min(parsePositiveInt(req.query.limit, 50), 200);
    const skip = (page - 1) * limit;

    const [total, data] = await Promise.all([
      prisma.client.count({ where: { tenantId } }),
      prisma.client.findMany({
        where: { tenantId },
        orderBy: { createdAt: "desc" },
        skip,
        take: limit,
      }),
    ]);

    res.json({ data, page, limit, total });
  } catch (err) {
    next(err);
  }
});

router.post("/clients", async (req, res, next) => {
  try {
    const tenantId = req.tenantId;
    const { name, email, phone, document } = req.body || {};

    if (!name || !email) {
      const e = new Error("name and email are required");
      e.status = 400;
      throw e;
    }
    const emailOk = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    if (!emailOk) {
      const e = new Error("invalid email");
      e.status = 400;
      throw e;
    }

    const created = await prisma.client.create({
      data: { tenantId, name, email, phone, document },
    });
    res.status(201).json(created);
  } catch (err) {
    if (String(err.message).includes("Unique constraint")) {
      err.status = 409;
      err.message = "email already exists";
    }
    next(err);
  }
});

module.exports = router;
