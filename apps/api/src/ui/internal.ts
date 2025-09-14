import { Router } from "express";
const router = Router();

router.get("/health", (_req, res) => { res.json({ ok: true }); });
router.get("/metrics", (_req, res) => { res.type("text/plain").send("up 1"); });

export default router;
