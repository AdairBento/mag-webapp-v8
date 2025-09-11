/* eslint-disable no-unused-vars */
function createHealthHandler({ prisma } = {}) {
  return async (_req, res) => {
    const checks = {
      system: { status: "ok", message: "System OK" },
      database: { status: "skip", message: "No Prisma provided" },
    };
    if (prisma?.$queryRaw) {
      try {
        const _unused = await prisma.$queryRaw`SELECT 1`;
        checks.database = { status: "ok", message: "Database OK" };
      } catch (e) {
        checks.database = { status: "error", message: e?.message || "DB error" };
      }
    }
    res.json({
      status: checks.database.status === "error" ? "error" : "ok",
      timestamp: new Date().toISOString(),
      uptime_ms: Math.round(process.uptime() * 1000),
      checks,
    });
  };
}
module.exports = { createHealthHandler };
