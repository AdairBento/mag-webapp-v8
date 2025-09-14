const { PrismaClient } = require("@prisma/client");
(async () => {
  const prisma = new PrismaClient();
  try {
    await prisma.tenant.upsert({
      where:  { id: "dev" },
      update: { name: "Development", domain: "dev.local" },
      create: { id: "dev", name: "Development", domain: "dev.local" }
    });
    console.log("OK: tenant dev");
    process.exit(0);
  } catch (e) {
    console.error("Seed error:", e);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
})();
