// @scaffold-managed
import { randomUUID } from "crypto";
import type { Request, Response, NextFunction } from "express";

export default function requestId(req: Request, _res: Response, next: NextFunction){
  (req as any).id = (req.headers["x-request-id"] as string) || randomUUID();
  next();
}
