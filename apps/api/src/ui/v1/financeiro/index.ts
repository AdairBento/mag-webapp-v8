// @scaffold-managed
import { Router } from "express";
import * as service from "../../../services/financeiroService";
const router = Router();
router.post("/cobranca", async (req, res) => {
  // const v = service.exemplo();
  res.json({ ok: true, modulo: "financeiro" });
});
router.post("/acao", async (req, res) => {
  res.json({ ok: true });
});
export default router;
