import express from "express";
import listEndpoints from "express-list-endpoints";
import internal from "../src/ui/internal";
import v1 from "../src/ui/v1";

const app = express();
app.use("/internal", internal);
app.use("/v1", v1);

const endpoints = listEndpoints(app);
console.log("# Rotas da API");
for (const e of endpoints) {
  const methods = (e.methods as string[]).join(", ");
  console.log("- " + e.path + " - " + methods);
}
