import express from "express";
import internal from "./ui/internal";
import v1 from "./ui/v1";

export function createServer() {
  const app = express();
  app.use(express.json());

  app.use("/internal", internal);

  
  app.use("/v1", v1);
  // 404 para rota não encontrada na API
  app.use((_req, res) => res.status(404).json({ error: "route_not_found" }));
  return app;
}


