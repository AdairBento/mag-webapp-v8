import financeiro from "./financeiro";
import manutencao from "./manutencao";
import locacao from "./locacao";
import { Router } from "express";
const router = Router();

router.get("/ping", (_req, res) => { res.json({ pong: true }); });

router.use("/locacao", locacao);
router.use("/manutencao", manutencao);
router.use("/financeiro", financeiro);
export default router;

