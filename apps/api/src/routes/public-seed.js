/* eslint-env node */
/* global URL, fetch */
const express = require("express");
const router = express.Router();

// OBS: aqui definimos APENAS o caminho relativo a /api/v1
router.post("/tenants/:tenantId/seed", async (req, res) => {
  try {
    const tenantId = req.params.tenantId;
    const qty = Number((req.body && req.body.qty) ?? req.query.qty ?? 5);

    if (!tenantId) return res.status(400).json({ error: "tenantId_required" });
    if (!Number.isInteger(qty) || qty <= 0) return res.status(400).json({ error: "invalid_qty" });

    const url = new URL("http://127.0.0.1:3000/internal/seed");
    url.searchParams.set("tenantId", tenantId);
    url.searchParams.set("qty", String(qty));

    const resp = await fetch(url.toString(), { method: "POST" });
    const data = await resp.json().catch(() => ({}));
    if (!resp.ok) return res.status(resp.status).json({ error: "seed_failed", detail: data });

    return res.status(201).json({ ok: true, ...data });
  } catch (err) {
    console.error("[public seed] error:", err);
    return res.status(500).json({ error: "internal_error" });
  }
});

module.exports = router;

