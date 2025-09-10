param(
  [ValidateSet("start","stop","status")]
  [string]$Cmd = "status",
  [int]$Port = 3000
)

$ErrorActionPreference = "Stop"

function Get-PortPids([int]$p) {
  try {
    (Get-NetTCPConnection -LocalPort $p -State Listen | Select-Object -ExpandProperty OwningProcess -Unique) 2>$null
  } catch { $null }
}

function Stop-Port([int]$p) {
  $pids = Get-PortPids $p
  if ($pids) {
    foreach ($procId in $pids) { Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue }
    Write-Host "[OK] Liberada porta $p (processos: $($pids -join ', '))"
  } else {
    Write-Host "[OK] Porta $p já está livre."
  }
}

function Status-Port([int]$p) {
  $pids = Get-PortPids $p
  if ($pids) {
    Write-Host "Porta $p em uso por PID(s): $($pids -join ', ')"
  } else {
    Write-Host "Porta $p livre."
  }
}

switch ($Cmd) {
  "status" { Status-Port $Port; break }
  "stop"   { Stop-Port  $Port; break }
  "start"  {
    Stop-Port $Port
    $env:PORT = $Port
    Write-Host "[INFO] Subindo API em http://localhost:$Port ..."
    nodemon "mag-webapp-v8-integrated/apps/api/src/index.js"
    break
  }
}
