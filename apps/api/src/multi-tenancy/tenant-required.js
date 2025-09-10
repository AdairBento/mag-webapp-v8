// apps/api/src/multi-tenancy/tenant-required.js
// Extrai tenantId do query, header ou body e injeta em req.tenantId
module.exports = function tenantRequired(req, res, next) {
  const t =
    req.query.tenantId ||
    req.headers["x-tenant-id"] ||
    (req.body && req.body.tenantId);

  if (!t || typeof t !== "string" || t.trim().length < 8) {
    return res.status(400).json({ error: { message: "tenantId is required" } });
  }
  req.tenantId = t.trim();
  next();
};
