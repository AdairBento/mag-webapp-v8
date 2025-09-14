import * as client from "prom-client";
import onFinished from "on-finished";

const register = client.register;
client.collectDefaultMetrics({ register, prefix: "app_" });

export const httpRequestsTotal = new client.Counter({
  name: "http_requests_total",
  help: "Total de requests HTTP",
  labelNames: ["method", "route", "status_code"] as const,
});

export const httpRequestDurationSeconds = new client.Histogram({
  name: "http_request_duration_seconds",
  help: "Duração dos requests HTTP em segundos",
  labelNames: ["method", "route", "status_code"] as const,
  buckets: [0.01,0.02,0.03,0.05,0.075,0.1,0.2,0.3,0.5,0.75,1,2,3,5],
});

export const vehiclesCreated = new client.Counter({
  name: "business_vehicles_created_total",
  help: "Veículos criados",
  labelNames: ["tenant"] as const,
});

function normalizeRoute(req: any): string {
  const r = (req.route?.path ?? req.originalUrl ?? req.url ?? "") as string;
  return r
    .replace(/[0-9a-fA-F-]{36}/g, ":uuid")
    .replace(/\/\d+(\b|\/)/g, "/:id");
}

export function metricsMiddleware(req: any, res: any, next: any) {
  const start = process.hrtime.bigint();
  onFinished(res, () => {
    const route = normalizeRoute(req);
    const method = String(req.method || "GET").toUpperCase();
    const status = String(res.statusCode || 0);
    httpRequestsTotal.labels(method, route, status).inc();
    const end = process.hrtime.bigint();
    const seconds = Number(end - start) / 1e9;
    httpRequestDurationSeconds.labels(method, route, status).observe(seconds);
  });
  next();
}

export async function metricsEndpoint(_req: any, res: any) {
  res.set("Content-Type", register.contentType);
  res.send(await register.metrics());
}
