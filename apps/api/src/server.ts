import express from "express";
import internal from "./ui/internal";
import v1 from "./ui/v1";

export function createServer() {
  const app = express();
  app.use(express.json());

  app.use("/internal", internal);

  
  app.use("/v1", v1);
  // 404 para rota não encontrada na API
  app.use((_req, res) => res.status(404).json({ error: "route_not_found" }));
    // tratador de erro central (log + 500)
  app.use((err: any, _req: any, res: any, _next: any) => {
    // eslint-disable-next-line no-console
    console.error(err);
    res.status(500).json({ error: "internal_error" });
  });
  return app;
}



