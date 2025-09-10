import { Router, type Express } from "express";
import client from "prom-client";

const registry = new client.Registry();
client.collectDefaultMetrics({ register: registry });

export const registerMetrics = (_app: Express) => {
  // aqui poderíamos registrar métricas customizadas
};

export const metricsRouter = () => {
  const r = Router();
  r.get("/", async (_req, res) => {
    res.set("Content-Type", registry.contentType);
    res.end(await registry.metrics());
  });
  return r;
};
