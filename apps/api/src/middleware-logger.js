const { randomUUID } = require("node:crypto");
function addTraceId(req, _res, next) {
  req.traceId = req.headers["x-trace-id"] || randomUUID();
  next();
}
function httpLogger(req, res, next) {
  const start = Date.now();
  const { method, originalUrl } = req;
  const traceId = req.traceId;
  res.on("finish", () => {
    const ms = Date.now() - start;
    console.log(`${method} ${originalUrl} -> ${res.statusCode} (${ms}ms) [traceId=${traceId}]`);
  });
  next();
}
module.exports = { addTraceId, httpLogger };
