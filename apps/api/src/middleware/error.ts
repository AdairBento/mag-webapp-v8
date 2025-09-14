// @scaffold-managed
import type { Request, Response, NextFunction } from "express";
import logger from "../utils/logger";

export default function errorHandler(err: any, _req: Request, res: Response, _next: NextFunction){
  logger.error(err);
  res.status(500).json({ error: "internal_error" });
}
