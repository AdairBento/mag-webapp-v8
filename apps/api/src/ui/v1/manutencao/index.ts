// @scaffold-managed
import { Router } from "express";
import * as service from "../../../services/manutencaoService";
const router = Router();
router.post("/ordem", async (req, res) => {
  // const v = service.exemplo();
  res.json({ ok: true, modulo: "manutencao" });
});
router.post("/acao", async (req, res) => {
  res.json({ ok: true });
});
export default router;
