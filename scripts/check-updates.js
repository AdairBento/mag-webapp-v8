#!/usr/bin/env node
/* eslint-disable no-unused-vars */
const { execSync } = require("node:child_process");

const cmds = [
  "npm audit --audit-level=moderate || exit 0",
  "npm outdated || exit 0",
  "npm test -- --passWithNoTests || exit 0",
  "npm run lint || exit 0",
];

for (const c of cmds) {
  console.log(`\n⚡ ${c}`);
  try {
    const _out = execSync(c, { stdio: "inherit", shell: true });
  } catch (_e) {
    // segue adiante para ver todas as saídas
  }
}
console.log("\n✅ Verificações concluídas.");
