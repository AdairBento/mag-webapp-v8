// apps/api/src/routes/availability.routes.js
const { Router } = require("express");
const { normalizeAvailabilityParams } = require("../availability-alias");

function requireNonEmpty(v, field) {
  if (v == null || String(v).trim() === "") {
    const e = new Error(`${field} é obrigatório`); e.status = 400; e.payload = { field }; throw e;
  }
  return v;
}

module.exports = ({ prisma }) => {
  const r = Router();

  // define apenas "/availability" aqui; vamos montar o router duas vezes ("/api/v1" e "/")
  r.get("/availability", normalizeAvailabilityParams, async (req, res, next) => {
    try {
      const tenantId = requireNonEmpty(req.query.tenantId, "tenantId");

      const { startDate, endDate } = req.query;
      const start = req.availabilityWindow?.start ? req.availabilityWindow.start : new Date(startDate);
      const end   = req.availabilityWindow?.end   ? req.availabilityWindow.end   : new Date(endDate);

      const blockingStatuses = ["confirmed"];
      const overlapping = await prisma.rental.findMany({
        where: {
          tenantId,
          status: { in: blockingStatuses },
          NOT: [{ endDate: { lte: start } }, { startDate: { gte: end } }],
        },
        select: { vehicleId: true },
      });

      const blockedIds = [...new Set(overlapping.map((r) => r.vehicleId))];

      const mode = String(req.query.mode || "available").toLowerCase();
      let vehicleWhere;
      if (mode === "blocked") {
        vehicleWhere = { tenantId, ...(blockedIds.length ? { id: { in: blockedIds } } : { id: { in: [] } }) };
      } else {
        vehicleWhere = { tenantId, status: "available", ...(blockedIds.length ? { id: { notIn: blockedIds } } : {}) };
      }

      const data = await prisma.vehicle.findMany({ where: vehicleWhere, orderBy: { createdAt: "desc" } });
      const total = await prisma.vehicle.count({ where: vehicleWhere });

      res.json({
        data,
        pagination: { page: 1, limit: data.length, total, pages: 1 },
        meta: {
          mode: req.query.mode || "available",
          blockedVehicleCount: blockedIds.length,
          window: { startDate: req.query.startDate, endDate: req.query.endDate },
        },
      });
    } catch (e) {
      next(e);
    }
  });

  return r;
};
