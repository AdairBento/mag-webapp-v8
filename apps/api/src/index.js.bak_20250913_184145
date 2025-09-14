const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const fs = require("fs");
const path = require("path");

const app = express();

app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));

// Healthcheck simples
app.get("/internal/health", (_, res) => res.json({ ok: true }));

// Monta rota se o arquivo existir (evita crash por require faltando)
function mount(routeRelPath, basePath) {
  const full = path.join(__dirname, routeRelPath);
  if (fs.existsSync(full)) {
    app.use(basePath, require(full));
    console.log(`Mounted ${basePath} -> ${routeRelPath}`);
  } else {
    console.warn(`WARN: route file not found: ${routeRelPath}`);
  }
}

// Monte só o que temos
mount("./routes/rentals.routes.js", "/api/v1/rentals");
mount("./routes/maintenances.routes.js", "/api/v1/maintenances");
mount("./routes/tenants.routes.js", "/api/v1/tenants");

mount('./routes/clients.routes.js', '/api/v1/clients');
mount('./routes/vehicles.routes.js', '/api/v1/vehicles');
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API listening on http://localhost:${PORT}`));

// teste husky 2
