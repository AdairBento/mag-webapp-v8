import { Request, Response, NextFunction } from "express";
// placeholder compatível com contratos; regras reais depois
export function rbac(_opts: { optional?: boolean } = {}) {
  return (_req: Request, _res: Response, next: NextFunction) => next();
}
