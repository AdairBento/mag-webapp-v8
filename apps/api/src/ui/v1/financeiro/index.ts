// @scaffold-managed
import { Router } from "express";
import * as service from "../../../services/financeiroService";

const router = Router();
router.post("/cobranca", async (req, res) => {
  // const v = service.exemplo();
  res.json({ ok: true, modulo: "financeiro" });
});
export default router;



