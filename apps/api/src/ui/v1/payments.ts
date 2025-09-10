import { Router } from "express";
export const paymentsRouter = () => {
  const r = Router();
  r.post("/charge", (_req, res) => res.status(202).json({ accepted: true }));
  return r;
};
