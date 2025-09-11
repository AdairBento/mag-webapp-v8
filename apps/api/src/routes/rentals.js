const express = require("express");
const prisma = require("../db");
const { hasConflict, createRentalAndReserveVehicle } = require("../services/rentals.service");
const router = express.Router();

function parsePositiveInt(v, def) {
  const n = parseInt(v, 10);
  return Number.isFinite(n) && n > 0 ? n : def;
}
function parseIsoDate(d) {
  const dt = new Date(d);
  return isNaN(dt.getTime()) ? null : dt;
}

router.get("/rentals", async (req, res, next) => {
  try {
    const tenantId = req.tenantId;
    const page = parsePositiveInt(req.query.page, 1);
    const limit = Math.min(parsePositiveInt(req.query.limit, 50), 200);
    const skip = (page - 1) * limit;

    const [total, data] = await Promise.all([
      prisma.rental.count({ where: { tenantId } }),
      prisma.rental.findMany({
        where: { tenantId },
        orderBy: { startDate: "desc" },
        skip,
        take: limit,
        include: {
          client: { select: { id: true, name: true, email: true } },
          vehicle: { select: { id: true, plate: true, model: true, brand: true } },
        },
      }),
    ]);

    res.json({ data, page, limit, total });
  } catch (err) {
    next(err);
  }
});

router.post("/rentals", async (req, res, next) => {
  try {
    const tenantId = req.tenantId;
    const {
      clientId,
      vehicleId,
      startDate: startRaw,
      endDate: endRaw,
      status,
      price,
      notes,
    } = req.body || {};

    if (!clientId || !vehicleId || !startRaw || !endRaw) {
      const e = new Error("clientId, vehicleId, startDate, endDate are required");
      e.status = 400;
      throw e;
    }

    const startDate = parseIsoDate(startRaw);
    const endDate = parseIsoDate(endRaw);
    if (!startDate || !endDate || startDate >= endDate) {
      const e = new Error("invalid date range");
      e.status = 400;
      throw e;
    }

    const [client, vehicle] = await Promise.all([
      prisma.client.findFirst({ where: { id: clientId, tenantId } }),
      prisma.vehicle.findFirst({ where: { id: vehicleId, tenantId } }),
    ]);
    if (!client) {
      const e = new Error("client not found in tenant");
      e.status = 404;
      throw e;
    }
    if (!vehicle) {
      const e = new Error("vehicle not found in tenant");
      e.status = 404;
      throw e;
    }

    const conflict = await hasConflict(prisma, tenantId, vehicleId, startDate, endDate);
    if (conflict) {
      const e = new Error("rental conflict for this vehicle and period");
      e.status = 409;
      throw e;
    }

    const payload = {
      tenantId,
      clientId,
      vehicleId,
      startDate,
      endDate,
      status: status || "reserved",
      price: price != null ? Number(price) : null,
      notes: notes || null,
    };

    const rental = await createRentalAndReserveVehicle(prisma, payload);
    res.status(201).json(rental);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
