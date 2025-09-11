function normalizeAmount(value) {
  if (typeof value === "string" && /^\d+\.\d{2}$/.test(value)) {
    return value;
  }

  if (typeof value === "number") {
    return value.toFixed(2);
  }

  throw new Error("Invalid amount format");
}

module.exports = { normalizeAmount };
