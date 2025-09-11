function normalizeAvailabilityParams(req, res, next) {
  const q = { ...(req.query || {}) };

  // aliases ?from/?to -> ?startDate/?endDate
  if (!q.startDate && q.from) q.startDate = q.from;
  if (!q.endDate && q.to) q.endDate = q.to;
  delete q.from;
  delete q.to;

  if (!q.startDate || !q.endDate) {
    return res.status(400).json({
      error: "bad_request",
      message: "missing_date_params",
      details: { expected: ["startDate", "endDate"] },
    });
  }

  const isValidISO = (s) => typeof s === "string" && /^\d{4}-\d{2}-\d{2}(?:$|T)/.test(s);
  if (!isValidISO(q.startDate) || !isValidISO(q.endDate)) {
    return res.status(400).json({
      error: "invalid_date",
      message: "invalid_date",
      details: { startDate: q.startDate, endDate: q.endDate },
    });
  }

  const start = new Date(q.startDate);
  const end = new Date(q.endDate);
  if (Number.isNaN(start.getTime()) || Number.isNaN(end.getTime())) {
    return res.status(400).json({ error: "invalid_date_parse" });
  }

  req.query = q;
  req.availabilityWindow = { start, end };
  next();
}
module.exports = { normalizeAvailabilityParams };
