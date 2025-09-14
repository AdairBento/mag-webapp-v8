const { Router } = require("express");
const health = require("./health").default || require("./health");
const metrics = require("./metrics").default || require("./metrics");

const router = Router();
router.use("/health", health);
router.use("/metrics", metrics);

module.exports = router;
