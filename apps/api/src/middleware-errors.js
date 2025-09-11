class ApiError extends Error {
  constructor(error, message, statusCode = 400, details) {
    super(message);
    this.name = "ApiError";
    this.error = error;
    this.statusCode = statusCode;
    this.details = details;
  }
}
function errorHandler(err, req, res, _next) {
  const status = err?.statusCode || err?.status || 500;
  const error =
    err?.code ||
    (status === 400
      ? "bad_request"
      : status === 404
        ? "not_found"
        : status === 409
          ? "conflict"
          : status === 422
            ? "unprocessable_entity"
            : "internal_error");
  const payload = { error, message: err?.message || "internal_error" };
  if (err?.details) payload.details = err.details;
  if (req?.traceId) payload.traceId = req.traceId;
  res.status(status).json(payload);
}
module.exports = { ApiError, errorHandler };
