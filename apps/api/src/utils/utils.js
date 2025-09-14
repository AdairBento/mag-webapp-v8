function requireNonEmpty(value, name) {
  if (value === undefined || value === null || value === "") {
    const err = new Error(`${name} é obrigatório`);
    err.name = "ValidationError";
    throw err;
  }
}
module.exports = { requireNonEmpty };
'@ | Set-Content -Path 'apps\api\src\utils.js' -Encoding UTF8

