import rateLimit from "express-rate-limit";

export const rateLimiter = () => {
  const windowMs = Number(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000;
  const max = Number(process.env.RATE_LIMIT_MAX_REQUESTS) || 100;

  return rateLimit({
    windowMs,
    max,
    message: {
      error: "too many requests",
      code: "RATE_LIMIT_EXCEEDED",
      retryAfter: Math.ceil(windowMs / 1000)
    },
    standardHeaders: true,
    legacyHeaders: false,
    keyGenerator: (req: any) => {
      const tenantId = (req.tenantId as string) || "default";
      return `${req.ip}:${tenantId}`;
    }
  });
};