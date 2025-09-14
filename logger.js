const { Logtail } = require("@logtail/node");
const pino = require("pino");

const token = process.env.LOGTAIL_TOKEN;
let transport;
if (token) {
  transport = {
    target: "@logtail/pino",
    options: { logtail: new Logtail(token) }
  };
}
module.exports = pino({ level: process.env.LOG_LEVEL || "info", transport });
