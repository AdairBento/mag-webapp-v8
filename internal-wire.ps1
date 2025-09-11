param([switch]$Apply)

$ErrorActionPreference = "Stop"
$Api = "apps/api/src"
$Idx = Join-Path $Api "index.js"
$UiDir = Join-Path $Api "ui/internal"
$UiIdx = Join-Path $UiDir "index.js"
$Hx = Join-Path $Api "health-extended.js"

function Step($t){Write-Host $t -ForegroundColor Cyan}
function Ok($t){Write-Host $t -ForegroundColor Green}
function Warn($t){Write-Host $t -ForegroundColor Yellow}
function Err($t){Write-Host $t -ForegroundColor Red}

if (-not (Test-Path $Idx)) { Err "index.js não encontrado em $Idx"; exit 1 }

$plan = @()

# 1) health-extended.js (fábrica)
$needHx = $true
if (Test-Path $Hx) {
  $c = Get-Content $Hx -Raw
  if ($c -match "module\.exports\s*=\s*createHealthHandler") { $needHx = $false }
}
$plan += [pscustomobject]@{ Item="health-extended.js"; Action= if($needHx){"create/update"}else{"ok"}; Path=$Hx }

# 2) ui/internal/index.js (router clients)
$needUi = -not (Test-Path $UiIdx)
$plan += [pscustomobject]@{ Item="internal router"; Action= if($needUi){"create"}else{"ok"}; Path=$UiIdx }

# 3) index.js wires/imports e ordem
$idxContent = Get-Content $Idx -Raw
$needImport = $idxContent -notmatch "createHealthHandler\s*=\s*require\('./health-extended'\)"
$needHealth = $idxContent -notmatch 'app\.get\("/internal/health"'
$needExt   = $idxContent -notmatch 'app\.get\("/internal/health/extended"'
$hasWire   = $idxContent -match 'app\.use\("/internal",\s*require\("\.\/ui\/internal"\)\)'
$needWire  = -not $hasWire
$plan += [pscustomobject]@{ Item="index.js import createHealthHandler"; Action= if($needImport){"inject"}else{"ok"}; Path=$Idx }
$plan += [pscustomobject]@{ Item="index.js /internal/health"; Action= if($needHealth){"inject"}else{"ok"}; Path=$Idx }
$plan += [pscustomobject]@{ Item="index.js /internal/health/extended"; Action= if($needExt){"inject"}else{"ok"}; Path=$Idx }
$plan += [pscustomobject]@{ Item="index.js app.use('/internal', ...)"; Action= if($needWire){"inject"}else{"ok"}; Path=$Idx }
$plan += [pscustomobject]@{ Item="index.js wire order"; Action="ensure-before-listen"; Path=$Idx }

Step "`nPlano:"
$plan | Format-Table -AutoSize

if (-not $Apply) {
  Warn "`nDry-run: nada será alterado. Rode com -Apply para executar."
  exit 0
}

# === APPLY ===
# backup do index.js
$backup = Join-Path $Api ("index.backup-" + (Get-Date -Format 'yyyyMMdd-HHmmss') + ".js")
Copy-Item $Idx $backup -Force
Ok "Backup do index.js -> $backup"

# 1) health-extended.js
if ($needHx) {
@'
function createHealthHandler({ prisma } = {}) {
  return async (req, res) => {
    const out = {
      status: "ok",
      timestamp: new Date().toISOString(),
      uptime_ms: Math.floor(process.uptime() * 1000),
      checks: { system: "ok", database: "" }
    };
    if (prisma && typeof prisma.$queryRaw === "function") {
      try { await prisma.$queryRaw`SELECT 1`; out.checks.database = "ok"; }
      catch (e) { out.checks.database = "error"; out.status = "degraded"; out.error = String(e?.message || e); }
    }
    res.json(out);
  };
}
module.exports = createHealthHandler;
'@ | Set-Content -Path $Hx -Encoding UTF8
Ok "health-extended.js pronto"
}

# 2) ui/internal/index.js
if ($needUi) {
if (-not (Test-Path $UiDir)) { New-Item -ItemType Directory -Force -Path $UiDir | Out-Null }
@'
const { Router } = require("express");
const router = Router();
router.get("/clients", (req, res) => {
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
'@ | Set-Content -Path $UiIdx -Encoding UTF8
Ok "router /internal pronto"
}

# 3) patches no index.js (injeções idempotentes)
$c = $idxContent

if ($needImport) {
  $c = "const createHealthHandler = require('./health-extended');`r`n" + $c
}

if ($needHealth) {
  $c += "`r`napp.get(""/internal/health"", (req,res)=> res.json({ status:""ok"", timestamp:new Date().toISOString() }));`r`n"
}

if ($needExt) {
  $c += "app.get(""/internal/health/extended"", createHealthHandler({ prisma }));`r`n"
}

# remove wires existentes para recolocar no lugar certo
$c = $c -replace '^\s*app\.use\("/internal".*?\);\s*','', 'Multiline'
# injeta o wire logo após express.json()
$c = $c -replace 'app\.use\(\s*express\.json\(\)\s*\);\s*',
  'app.use(express.json());'+"`r`n"+'app.use("/internal", require("./ui/internal"));'+"`r`n"

Set-Content -Path $Idx -Value $c -Encoding UTF8
Ok "index.js atualizado"

# 4) smoke rápido (sem mexer em package.json)
try {
  $env:PORT = 3000
  # mata quem ocupar a 3000
  Get-NetTCPConnection -LocalPort 3000 -State Listen -ErrorAction SilentlyContinue |
    Select-Object -Expand OwningProcess -Unique | % { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue } | Out-Null
} catch {}

# tenta subir via nodemon se estiver rodando; senão, apenas testa
Write-Host "`nTeste rápido:" -ForegroundColor Magenta
function T($u){ try{ $r=Invoke-RestMethod -Uri $u -TimeoutSec 6; "OK: $u"; $r|ConvertTo-Json -Depth 6 }catch{"FAIL: $u"; $_.Exception.Message } }
T "http://localhost:3000/internal/health"
T "http://localhost:3000/internal/health/extended"
T "http://localhost:3000/internal/clients"

Warn "`nSe não estiver com a API rodando, inicie com: cmd.exe /c npm run dev"
Ok  "Feito. Para reverter, restaure o backup: $backup"
