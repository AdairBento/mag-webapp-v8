import { Router } from "express";
export const reportsRouter = () => {
  const r = Router();
  r.get("/revenue", (_req, res) => res.json({ period: "tbd", totalRevenue: 0, currency: "BRL" }));
  return r;
};
