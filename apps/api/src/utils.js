function requireNonEmpty(value, name) {
  if (value === undefined || value === null || String(value).trim() === "") {
    const err = new Error(`${name} é obrigatório`);
    err.name = "ValidationError";
    throw err;
  }
}
module.exports = { requireNonEmpty };
