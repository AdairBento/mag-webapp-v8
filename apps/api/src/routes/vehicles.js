const express = require("express");
const prisma = require("../db");
const router = express.Router();

function parsePositiveInt(v, def) {
  const n = parseInt(v, 10);
  return Number.isFinite(n) && n > 0 ? n : def;
}
function isPlate(p) {
  return typeof p === "string" && /^[A-Z0-9-]{5,8}$/.test(p.toUpperCase());
}

router.get("/vehicles", async (req, res, next) => {
  try {
    const tenantId = req.tenantId;
    const page = parsePositiveInt(req.query.page, 1);
    const limit = Math.min(parsePositiveInt(req.query.limit, 50), 200);
    const skip = (page - 1) * limit;

    const [total, data] = await Promise.all([
      prisma.vehicle.count({ where: { tenantId } }),
      prisma.vehicle.findMany({
        where: { tenantId },
        orderBy: { createdAt: "desc" },
        skip,
        take: limit,
      }),
    ]);

    res.json({ data, page, limit, total });
  } catch (err) { next(err); }
});

router.post("/vehicles", async (req, res, next) => {
  try {
    const tenantId = req.tenantId;
    let { plate, brand, model, year, status, dailyRate } = req.body || {};

    if (!plate || !brand || !model || !year) {
      const e = new Error("plate, brand, model, year are required"); e.status = 400; throw e;
    }
    if (!isPlate(plate)) { const e = new Error("invalid plate"); e.status = 400; throw e; }

    plate = plate.toUpperCase();
    year = parseInt(year, 10);
    if (!Number.isFinite(year) || year < 1950) {
      const e = new Error("invalid year"); e.status = 400; throw e;
    }

    const created = await prisma.vehicle.create({
      data: {
        tenantId, plate, brand, model, year,
        status: status || "available",
        dailyRate: dailyRate != null ? Number(dailyRate) : null,
      },
    });
    res.status(201).json(created);
  } catch (err) {
    if (String(err.message).includes("Unique constraint")) {
      err.status = 409; err.message = "plate already exists";
    }
    next(err);
  }
});

module.exports = router;
