import { Router } from "express";
export const vehiclesRouter = () => {
  const r = Router();
  r.get("/", (_req, res) => res.json({ data: [] }));
  return r;
};
