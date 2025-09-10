import { Router } from "express";
export const healthRouter = () => {
  const r = Router();
  r.get("/", async (_req, res) => {
    res.status(200).json({ status: "ok" });
  });
  return r;
};
