import { Router } from "express";
export const metricsRouter = Router();
export function registerMetrics() { /* no-op */ }
metricsRouter.get("/metrics", (_req, res) => {
  res.type("text/plain").send("# no metrics\n");
});
export default metricsRouter;
