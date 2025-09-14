// apps/api/src/routes/diagnostics.routes.js
const { Router } = require("express");

module.exports = function createDiagnosticsRouter(app) {
  const r = Router();

  // Confirma o arquivo em execução
  r.get("/__probe", (_req, res) => res.json({ ok: true, file: __filename }));

  // Lista rotas registradas
  r.get("/internal/routes", (_req, res) => {
    const stack = (app._router && app._router.stack) ? app._router.stack : [];
    const routes = [];
    for (const layer of stack) {
      if (layer.route && layer.route.path) {
        const methods = Object.keys(layer.route.methods).filter(k => layer.route.methods[k]);
        routes.push({ path: layer.route.path, methods });
      } else if (layer.name === "router" && layer.handle && layer.handle.stack) {
        for (const r2 of layer.handle.stack) {
          if (r2.route && r2.route.path) {
            const methods = Object.keys(r2.route.methods).filter(k => r2.route.methods[k]);
            routes.push({ path: r2.route.path, methods, base: layer.regexp && layer.regexp.toString() });
          }
        }
      }
    }
    res.json({ routes });
  });

  return r;
};
