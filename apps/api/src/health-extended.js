function createHealthHandler({ prisma } = {}) {
  return async (req, res) => {
    const out = {
      status: "ok",
      timestamp: new Date().toISOString(),
      uptime_ms: Math.floor(process.uptime() * 1000),
      checks: { system: "ok", database: "" },
    };

    // Se houver Prisma, tenta um ping simples
    if (prisma && typeof prisma.$queryRaw === "function") {
      try {
        // SELECT 1 compatível; ajuste se seu client exigir outra forma
        await prisma.$queryRaw`SELECT 1`;
        out.checks.database = "ok";
      } catch (e) {
        out.checks.database = "error";
        out.status = "degraded";
        out.error = String(e?.message || e);
      }
    }

    res.json(out);
  };
}

module.exports = createHealthHandler;
