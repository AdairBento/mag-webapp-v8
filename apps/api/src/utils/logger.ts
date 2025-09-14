// @scaffold-managed
/* bem simples, sem dependências */
const logger = {
  info: (...a: any[]) => console.log(...a),
  warn: (...a: any[]) => console.warn(...a),
  error: (...a: any[]) => console.error(...a),
};
export default logger;
