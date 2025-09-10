import { Request, Response, NextFunction } from "express";

declare module "express-serve-static-core" {
  interface Request {
    tenantId?: string;
  }
}

export function tenantContext() {
  const headerName = process.env.X_TENANT_HEADER || "X-Tenant-ID";
  return (req: Request, _res: Response, next: NextFunction) => {
    const tenant = (req.headers[headerName.toLowerCase()] as string) || "default";
    req.tenantId = tenant;
    next();
  };
}
