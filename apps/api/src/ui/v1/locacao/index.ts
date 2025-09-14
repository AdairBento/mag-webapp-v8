// @scaffold-managed
import { Router } from "express";
import * as service from "../../../services/locacaoService";
const router = Router();
router.post("/registrar", async (req, res) => {
  // const v = service.exemplo();
  res.json({ ok: true, modulo: "locacao" });
});
router.post("/acao", async (req, res) => {
  res.json({ ok: true });
});
export default router;
