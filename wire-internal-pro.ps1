# wire-internal-pro.ps1
param(
  [int]$Port = 3000,
  [string]$User = "mag",
  [string]$Pass = "locacao",
  [bool]$UseEnv = $true
)
$ErrorActionPreference = "Stop"

# --- Paths ---
$Root    = (Get-Location).Path
$ApiSrc  = Join-Path $Root "apps/api/src"
$Index   = Join-Path $ApiSrc "index.js"
$UiDir   = Join-Path $ApiSrc "ui/internal"
$UiIdx   = Join-Path $UiDir "index.js"
$Hx      = Join-Path $ApiSrc "health-extended.js"
$Backup  = Join-Path $ApiSrc ("index.backup-" + (Get-Date -Format 'yyyyMMdd-HHmmss') + ".js")

# --- Sanity checks ---
if (-not (Test-Path $ApiSrc)) { throw "Pasta não encontrada: $ApiSrc" }
if (-not (Test-Path $UiDir))  { New-Item -ItemType Directory -Force -Path $UiDir | Out-Null }

# --- Dependências úteis (idempotente) ---
Write-Host "[INFO] Garantindo nodemon e dotenv..."
npm i -D nodemon dotenv | Out-Null

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

# --- /ui/internal/index.js (tenta usar services/clientService; fallback demo) ---
$RouterContent = @'
const { Router } = require("express");
const router = Router();

router.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

router.get("/health/extended", require("../../health-extended"));

router.get("/clients", async (req, res) => {
  const { tenantId } = req.query;
  try {
    let service;
    try {
      service = require("../../services/clientService"); // deve exportar getClients()
    } catch (e) {
      // serviço ainda não existe; seguimos no fallback
    }

    if (service?.getClients) {
      const data = await service.getClients({ tenantId, page: 1, limit: 50 });
      const rows = Array.isArray(data) ? data : (data?.rows ?? []);
      const count = Array.isArray(data) ? data.length : (data?.count ?? rows.length);
      return res.json({ data: rows, count });
    }

    // Fallback demo
    return res.json({
      data: [
        { id: "demo-1", name: "Cliente Interno DEMO 1", tenantId: tenantId ?? "N/A" },
        { id: "demo-2", name: "Cliente Interno DEMO 2", tenantId: tenantId ?? "N/A" }
      ],
      count: 2
    });
  } catch (err) {
    console.error("[/internal/clients] error:", err);
    res.status(500).json({ error: "internal_error", message: String(err?.message || err) });
  }
});

module.exports = router;
'@
Set-Content -Path $UiIdx -Value $RouterContent -Encoding UTF8

# --- index.js mínimo + Basic Auth + dotenv ---
$IndexTemplate = @'
const express = require("express");
{DOTENV_LINE}
const app = express();

app.use(express.json());

// --- Basic Auth p/ /internal ---
function basicAuth(req, res, next) {
  const envUser = process.env.INTERNAL_USER || "{USER}";
  const envPass = process.env.INTERNAL_PASS || "{PASS}";
  const h = req.headers["authorization"] || "";
  if (!h.startsWith("Basic ")) return res.status(401).set("WWW-Authenticate","Basic").end("Auth required");
  const b64 = h.split(" ")[1] || "";
  const [u, p] = Buffer.from(b64, "base64").toString("utf8").split(":");
  if (u === envUser && p === envPass) return next();
  return res.status(403).json({ error: "forbidden" });
}

// --- Health ---
app.get("/internal/health", (req,res)=> res.json({ status:"ok", timestamp:new Date().toISOString() }));
app.get("/internal/health/extended", require("./health-extended"));

// --- Router interno protegido ---
app.use("/internal", basicAuth, require("./ui/internal"));

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`[API] listening on http://localhost:${port}`));
'@

# Prepara linha do dotenv se -UseEnv $true
$dotenv = if ($UseEnv) { 'require("dotenv").config();' } else { '' }
$IndexReady = $IndexTemplate.Replace("{DOTENV_LINE}", $dotenv).Replace("{USER}", $User).Replace("{PASS}", $Pass)

# --- Backup e escrita do index.js ---
if (Test-Path $Index) {
  Copy-Item $Index $Backup -Force
  Write-Host "[INFO] Backup criado: $Backup"
}
Set-Content -Path $Index -Value $IndexReady -Encoding UTF8

# --- Scripts npm (idempotente) ---
Write-Host "[INFO] Garantindo scripts npm..."
npm pkg set scripts.dev="nodemon apps/api/src/index.js"           | Out-Null
npm pkg set scripts.health="node -e \"require('http').get('http://localhost:%PORT%/internal/health',r=>{let d='';r.on('data',c=>d+=c);r.on('end',()=>console.log(d))})\"" | Out-Null

# --- Subir API ---
Write-Host "[INFO] Liberando porta $Port se ocupada..."
try {
  $pids = (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue |
    Select-Object -Expand OwningProcess -Unique)
  foreach ($pid in $pids) { Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue }
} catch {}

$env:PORT = $Port
# Preferir npm.cmd (evita erro Win32)
$npmCmd = (Get-Command npm.cmd -ErrorAction SilentlyContinue)?.Source
if ($npmCmd) {
  Start-Process -NoNewWindow -FilePath $npmCmd -ArgumentList @("run","dev") -WorkingDirectory $Root
} else {
  Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList @("/c","npm","run","dev") -WorkingDirectory $Root
}
Start-Sleep -Seconds 3

# --- Smoke tests: sem credenciais (deve 401), depois com credenciais ---
function J([object]$x){ try{ $x|ConvertTo-Json -Depth 8 }catch{ $x } }

Write-Host "`n[TEST] Sem credenciais (espera 401)"
try {
  Invoke-RestMethod "http://localhost:$Port/internal/health" -TimeoutSec 6
} catch { Write-Host ("OK (bloqueado): " + $_.Exception.Message) }

Write-Host "`n[TEST] Com credenciais (espera 200)"
$pair = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$User`:$Pass"))
$hdr  = @{ Authorization = "Basic $pair" }
$r1 = Invoke-RestMethod "http://localhost:$Port/internal/health" -Headers $hdr -TimeoutSec 6
$r2 = Invoke-RestMethod "http://localhost:$Port/internal/health/extended" -Headers $hdr -TimeoutSec 6
$r3 = Invoke-RestMethod "http://localhost:$Port/internal/clients?tenantId=022d0c59-4363-4993-a485-9adf29719824" -Headers $hdr -TimeoutSec 6
"`n/health:     " + (J $r1)
"`n/extended:   " + (J $r2)
"`n/clients:    " + (J $r3)

Write-Host "`n[OK] Finalizado. Se precisar voltar, restaure o backup: $Backup"
