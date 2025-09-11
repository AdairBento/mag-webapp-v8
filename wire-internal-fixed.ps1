# wire-internal-fixed.ps1
param([int]$Port = 3000)
$ErrorActionPreference = "Stop"

# --- Paths ---
$Root   = (Get-Location).Path
$ApiSrc = Join-Path $Root "apps/api/src"
$Index  = Join-Path $ApiSrc "index.js"
$UiDir  = Join-Path $ApiSrc "ui/internal"
$UiIdx  = Join-Path $UiDir "index.js"
$Hx     = Join-Path $ApiSrc "health-extended.js"

# --- Garantir pastas ---
if (-not (Test-Path $ApiSrc)) { throw "Pasta não encontrada: $ApiSrc" }
if (-not (Test-Path $UiDir))  { New-Item -ItemType Directory -Force -Path $UiDir | Out-Null }

# --- health-extended.js ---
$HealthContent = @'
module.exports = (req, res) => {
  const uptimeMs = Math.floor(process.uptime() * 1000);
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    uptime_ms: uptimeMs,
    checks: { system: "", database: "" }
  });
};
'@
Set-Content -Path $Hx -Value $HealthContent -Encoding UTF8

# --- /ui/internal/index.js ---
$RouterContent = @'
const { Router } = require("express");
const router = Router();

router.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

router.get("/health/extended", require("../../health-extended"));

router.get("/clients", async (req, res) => {
  const { tenantId } = req.query;
  res.json({
    data: [
      { id: "demo-1", name: "Cliente Interno DEMO 1", tenantId: tenantId ?? "N/A" },
      { id: "demo-2", name: "Cliente Interno DEMO 2", tenantId: tenantId ?? "N/A" }
    ],
    count: 2
  });
});

module.exports = router;
'@
Set-Content -Path $UiIdx -Value $RouterContent -Encoding UTF8

# --- index.js mínimo e funcional ---
$IndexContent = @'
const express = require("express");
const app = express();

app.use(express.json());

app.get("/internal/health", (req,res)=> res.json({ status:"ok", timestamp:new Date().toISOString() }));
app.get("/internal/health/extended", require("./health-extended"));
app.use("/internal", require("./ui/internal"));

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`[API] listening on http://localhost:${port}`));
'@
Set-Content -Path $Index -Value $IndexContent -Encoding UTF8

# --- Subir API via cmd.exe (usa npm.cmd por trás) ---
$env:PORT = $Port
Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList @("/c","npm","run","dev") -WorkingDirectory $Root
Start-Sleep -Seconds 3

# --- Smoke tests ---
function T([string]$u){
  try { $r=Invoke-RestMethod $u -TimeoutSec 8; "`nOK: $u"; $r|ConvertTo-Json -Depth 6 }
  catch { "FAIL: $u"; $_.Exception.Message }
}
T "http://localhost:$Port/internal/health"
T "http://localhost:$Port/internal/health/extended"
T "http://localhost:$Port/internal/clients"
T "http://localhost:$Port/internal/clients?tenantId=022d0c59-4363-4993-a485-9adf29719824"
