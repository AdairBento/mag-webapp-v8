function overlaps(aStart, aEnd, bStart, bEnd) {
  return aStart <= bEnd && bStart <= aEnd;
}

async function hasConflict(prisma, tenantId, vehicleId, startDate, endDate) {
  const candidates = await prisma.rental.findMany({
    where: {
      tenantId,
      vehicleId,
      status: { in: ["reserved", "active"] },
      startDate: { lte: endDate },
      endDate: { gte: startDate },
    },
    select: { id: true, startDate: true, endDate: true, status: true },
  });
  return candidates.some((r) => overlaps(startDate, endDate, r.startDate, r.endDate));
}

async function createRentalAndReserveVehicle(prisma, payload) {
  const [rental] = await prisma.$transaction([
    prisma.rental.create({ data: payload }),
    prisma.vehicle.update({
      where: { id: payload.vehicleId },
      data: { status: "reserved" },
    }),
  ]);
  return rental;
}

module.exports = { overlaps, hasConflict, createRentalAndReserveVehicle };
