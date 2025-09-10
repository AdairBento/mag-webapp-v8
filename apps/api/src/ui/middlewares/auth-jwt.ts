import { Request, Response, NextFunction } from "express";
// placeholder: validação real entra depois
export function authJwt(opts: { optional?: boolean } = {}) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (opts.optional) return next();
    // validar Bearer token aqui (futuro)
    return res.status(401).json({ error: "unauthorized" });
  };
}
