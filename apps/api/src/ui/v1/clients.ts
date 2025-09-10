import { Router } from "express";
export const clientsRouter = () => {
  const r = Router();
  r.get("/", (_req, res) => res.json({ data: [] }));
  r.post("/", (_req, res) => res.status(201).json({ ok: true }));
  return r;
};
