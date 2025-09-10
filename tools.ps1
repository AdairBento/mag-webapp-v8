param(
  [ValidateSet(
    "api:start","api:stop","api:restart","api:health","api:port",
    "db:generate","db:migrate","db:studio","db:reset",
    "status"
  )]
  [string]$Cmd,
  [int]$Port = 3000
)

# --- Paths ---
$Root     = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$RepoRoot = Join-Path $Root "mag-webapp-v8-integrated"
$ApiDir   = Join-Path $RepoRoot "apps\api"
$EnvPath  = Join-Path $ApiDir ".env"
$DbFile   = Join-Path $ApiDir "prisma\dev.db"

# --- Helpers (ASCII only) ---
function _ok($msg)   { Write-Host "[OK] $msg" -ForegroundColor Green }
function _warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function _err($msg)  { Write-Host "[ERR] $msg" -ForegroundColor Red }
function _info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }

function _require-cmd($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    throw "Command '$name' not found in PATH."
  }
}

function _ensure-env() {
  if (-not (Test-Path $EnvPath)) {
    _warn ".env not found. Creating default (SQLite + PORT=$Port)."
@"
DATABASE_URL="file:./dev.db"
PORT=$Port
"@ | Out-File -FilePath $EnvPath -Encoding ascii
    _ok ".env created at $EnvPath"
  }
}

function _get-port-pid([int]$p) {
  (Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty OwningProcess -Unique)
}

function _kill-port([int]$p) {
  $portPid = _get-port-pid $p
  if ($portPid) {
    _info "Killing PID $portPid on port $p ..."
    Stop-Process -Id $portPid -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 300
    if (-not (_get-port-pid $p)) { _ok "Port $p is now free." } else { _warn "Port $p still in use." }
  } else {
    _info "Port $p already free."
  }
}

function _in-api([scriptblock]$block) {
  Push-Location $ApiDir
  try { & $block } finally { Pop-Location }
}

# --- API commands ---
function api:port {
  $portPid = _get-port-pid $Port
  if ($portPid) {
    $p = Get-Process -Id $portPid -ErrorAction SilentlyContinue
    _info ("Port {0} in use by PID {1} ({2})" -f $Port, $portPid, ($p.ProcessName))
  } else {
    _ok ("Port {0} is free" -f $Port)
  }
}

function api:start {
  _require-cmd npm
  _ensure-env
  _kill-port $Port
  _in-api {
    $env:PORT = $Port
    _info "Starting API at http://localhost:$env:PORT ..."
    npm run dev
  }
}

function api:stop     { _kill-port $Port }
function api:restart  { api:stop; api:start }

function api:health {
  try {
    $url = "http://localhost:$Port/internal/health"
    _info "GET $url"
    $r = Invoke-RestMethod -Uri $url -Method GET -TimeoutSec 3
    _ok ("Health OK: " + ($r | ConvertTo-Json -Depth 5))
  } catch {
    _err ("Health failed: " + $_.Exception.Message)
  }
}

# --- DB commands (Prisma/SQLite) ---
function db:generate { _require-cmd npx; _in-api { npx prisma generate } }
function db:migrate  { _require-cmd npx; _in-api { npx prisma migrate dev } }
function db:studio   { _require-cmd npx; _in-api { npx prisma studio } }

function db:reset {
  _require-cmd npx
  _in-api {
    if (Test-Path $DbFile) {
      _warn "Removing $DbFile ..."
      Remove-Item $DbFile -Force
    } else {
      _info "Nothing to remove ($DbFile not found)."
    }
    _info "Sync schema -> SQLite (db push)"
    npx prisma db push
    _ok "DB recreated."
  }
}

# --- Status ---
function status {
  Write-Host "=== STATUS ===" -ForegroundColor Magenta
  Write-Host "RepoRoot: $RepoRoot"
  Write-Host "ApiDir:   $ApiDir"
  Write-Host "Port:     $Port"
  api:port
  foreach ($p in @("$ApiDir\src\index.js", "$ApiDir\prisma\schema.prisma", $EnvPath)) {
    if (Test-Path $p) { _ok "OK: $p" } else { _warn "MISSING: $p" }
  }
  if (Test-Path $DbFile) {
    $size = (Get-Item $DbFile).Length
    _info ("DB: {0} ({1:N0} bytes)" -f $DbFile, $size)
  } else {
    _warn "DB missing: $DbFile"
  }
}

# --- One-shot via -Cmd ---
if ($PSBoundParameters.ContainsKey("Cmd") -and $Cmd) {
  switch ($Cmd) {
    "api:start"   { api:start; break }
    "api:stop"    { api:stop; break }
    "api:restart" { api:restart; break }
    "api:health"  { api:health; break }
    "api:port"    { api:port; break }
    "db:generate" { db:generate; break }
    "db:migrate"  { db:migrate; break }
    "db:studio"   { db:studio; break }
    "db:reset"    { db:reset; break }
    "status"      { status; break }
    default       { _err "Unknown command: $Cmd"; break }
  }
}

