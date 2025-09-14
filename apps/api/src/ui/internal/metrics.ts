import { Router, Request, Response } from "express";
import { metricsEndpoint, metricsMiddleware } from "../../metrics";

const router = Router();
// opcional medir as rotas internas
router.use(metricsMiddleware);

// GET /internal/metrics
router.get("/", (req: Request, res: Response) => metricsEndpoint(req, res));

export default router;
