// @scaffold-managed
import request from "supertest";
import { createServer } from "../src/server";
const app = createServer();
it("POST /v1/manutencao/acao -> 200 { ok: true }", async () => {
  const res = await request(app).post("/v1/manutencao/acao").send({});
  expect(res.status).toBe(200);
  expect(res.body.ok).toBe(true);
});
