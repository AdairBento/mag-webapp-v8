const { Router } = require("express");
const router = Router();

router.get("/clients", (req, res) => {
  const { tenantId } = req.query;
  res.json({
    data: [
      { id: "demo-1", name: "Cliente Interno DEMO 1", tenantId: tenantId ?? "N/A" },
      { id: "demo-2", name: "Cliente Interno DEMO 2", tenantId: tenantId ?? "N/A" }
    ],
    count: 2
  });
});

module.exports = router;
