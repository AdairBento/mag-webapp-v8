import { createServer } from "./server";

const port = parseInt(process.env.PORT || "3000", 10);
const host = process.env.HOST || "0.0.0.0";

const app = createServer();
app.listen(port, host, () => {
  console.log(`API listening on http://${host}:${port}`);
});
