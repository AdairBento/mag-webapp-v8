# stop-api.ps1 (melhorado)
param([int]$Port = 3000, [switch]$All)
$ErrorActionPreference = 'SilentlyContinue'

function Stop-ByPort([int]$p) {
  $pidFile = "api.$p.pid"
  if (Test-Path $pidFile) {
    $childPid = [int](Get-Content $pidFile -Raw)
    Write-Host "⛔ Parando PID $childPid (porta $p) via pidfile"
    Stop-Process -Id $childPid -Force
    Remove-Item $pidFile -Force
  }
  $owners = Get-NetTCPConnection -State Listen -LocalPort $p -ErrorAction SilentlyContinue |
            Select-Object -Expand OwningProcess -Unique
  foreach ($ownerPid in $owners) {
    Write-Host "⛔ Matando PID $ownerPid (porta $p) via socket"
    Stop-Process -Id $ownerPid -Force
  }
  Write-Host "🛑 API parada na porta $p"
}

if ($All) {
  $pidFiles = Get-ChildItem -Filter 'api.*.pid' -ErrorAction SilentlyContinue
  if ($pidFiles) {
    foreach ($f in $pidFiles) {
      if ($f.BaseName -match '^api\.(\d+)\.pid$') { Stop-ByPort([int]$Matches[1]) }
    }
  } else {
    Write-Host "ℹ️ Nenhum pidfile encontrado. Tentando portas 3000..3010..."
    3000..3010 | ForEach-Object { Stop-ByPort $_ }
  }
} else {
  Stop-ByPort $Port
}
