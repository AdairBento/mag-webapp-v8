# start-api.ps1
param(
  [int]$Port = 3000,
  [switch]$Kill,          # mata quem estiver ouvindo na porta
  [switch]$Watch,         # usa nodemon se disponível
  [int]$TimeoutSec = 12,  # quanto tempo esperar o /internal/health
  [switch]$Open           # abre o health no browser ao subir
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Test-PortInUse([int]$p) {
  try { @(Get-NetTCPConnection -State Listen -LocalPort $p -ErrorAction Stop).Count -gt 0 } catch { $false }
}

function Kill-Port([int]$p) {
  $owners = Get-NetTCPConnection -State Listen -LocalPort $p -ErrorAction SilentlyContinue |
            Select-Object -Expand OwningProcess -Unique
  foreach ($ownerPid in $owners) {
    try {
      $proc = Get-Process -Id $ownerPid -ErrorAction Stop
      Write-Host "⛔ Matando PID $ownerPid na porta $p ($($proc.ProcessName))" -ForegroundColor Yellow
      Stop-Process -Id $ownerPid -Force -ErrorAction SilentlyContinue
    } catch {}
  }
  Start-Sleep -Milliseconds 300
}

function Find-FreePort([int]$start) {
  for ($p = $start; $p -le 65535; $p++) { if (-not (Test-PortInUse $p)) { return $p } }
  throw "Sem porta livre a partir de $start"
}

function Save-ChildPid([int]$p, [int]$childPid) { Set-Content -Path "api.$p.pid" -Value $childPid -Encoding ascii }
function Read-ChildPid([int]$p) { if (Test-Path "api.$p.pid") { [int](Get-Content "api.$p.pid" -Raw) } }
function Remove-ChildPid([int]$p) { if (Test-Path "api.$p.pid") { Remove-Item "api.$p.pid" -Force } }

function Start-Api([int]$p, [switch]$watch) {
  $env:PORT = $p
  $out = "api.$p.out.log"; $err = "api.$p.err.log"
  Remove-Item $out,$err -Force -ErrorAction SilentlyContinue

  $exe = "node"; $args = "apps/api/src/index.js"
  if ($watch -and (Get-Command nodemon -ErrorAction SilentlyContinue)) { $exe = "nodemon" }

  $child = Start-Process $exe -ArgumentList $args -PassThru `
           -RedirectStandardOutput $out -RedirectStandardError $err
  Save-ChildPid $p $child.Id
  return $child
}

function Wait-Health([int]$p, [int]$timeoutSec) {
  $deadline = (Get-Date).AddSeconds($timeoutSec)
  do {
    try {
      $h = Invoke-RestMethod -Uri "http://localhost:$p/internal/health" -TimeoutSec 1 -Method Get
      if ($h.status -eq 'ok') { return $true }
    } catch {}
    Start-Sleep -Milliseconds 400
  } while ((Get-Date) -lt $deadline)
  return $false
}

function Tail-Logs([int]$p) {
  $err="api.$p.err.log"; $out="api.$p.out.log"
  if (Test-Path $err) { Write-Host "`n--- $err (tail) ---" -ForegroundColor DarkGray; Get-Content $err -Tail 80 }
  if (Test-Path $out) { Write-Host "`n--- $out (tail) ---" -ForegroundColor DarkGray; Get-Content $out -Tail 40 }
}

# -------- main --------
if ($Port -eq 0) { $Port = Find-FreePort 3000 }
if ($Kill -or (Test-PortInUse $Port)) { Kill-Port $Port }

$child = Start-Api $Port $Watch
if (Wait-Health $Port $TimeoutSec) {
  Write-Host "✅ API UP em http://localhost:$Port" -ForegroundColor Green
  Write-Host "   Health:    http://localhost:$Port/internal/health"
  Write-Host "   Extended:  http://localhost:$Port/internal/health/extended"
  if ($Open) { Start-Process "http://localhost:$Port/internal/health" }
} else {
  Write-Host "❌ API não ficou saudável em $TimeoutSec s" -ForegroundColor Red
  Tail-Logs $Port
  exit 1
}
