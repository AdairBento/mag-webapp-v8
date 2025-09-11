import type { NextFunction, Request, Response } from "express";
import type pino from "pino";

export function errorHandler(logger: pino.Logger) {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  return (err: any, _req: Request, res: Response, _next: NextFunction) => {
    const status = err?.status || 500;
    logger.error({ err, status }, "unhandled_error");
    res.status(status).json({
      error: err?.message || "internal_error",
      details: process.env.NODE_ENV === "development" ? err : undefined,
    });
  };
}
