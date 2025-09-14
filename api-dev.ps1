function Get-ApiPid([int]$port=3000){
  $tcp = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
         Select-Object -First 1
  if($tcp){ return $tcp.OwningProcess }
  $line = netstat -ano | Select-String -Pattern ("LISTENING.*:{0}\s" -f $port) | Select-Object -First 1
  if($line){ return ($line.ToString().Trim() -split '\s+')[-1] }
  return $null
}

function Stop-Api([int]$port=3000){
  $procIdRaw = Get-ApiPid $port
  if($procIdRaw){
    $procId = [int]([regex]::Match("$procIdRaw",'\d+').Value)
    Write-Host "Matando API (PID=$procId) na porta $port..." -ForegroundColor Yellow
    Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
  } else {
    Write-Host "Nada escutando na porta $port." -ForegroundColor DarkGray
  }
}

function Start-Api {
  param([switch]$KillFirst,
        [string]$ApiPath = "C:\Users\adair\PythonProject\mag-webapp-v8\apps\api",
        [string]$Base    = "http://localhost:3000")

  if($KillFirst){ Stop-Api 3000 }

  $j = Get-Job -Name magapi -ErrorAction SilentlyContinue
  if($j){ Stop-Job $j -ErrorAction SilentlyContinue; Remove-Job $j -Force -ErrorAction SilentlyContinue }

  Push-Location $ApiPath
  try { Start-Job -Name magapi -ScriptBlock { npm run dev } | Out-Null } finally { Pop-Location }

  Write-Host "Subindo API..." -ForegroundColor Cyan
  $deadline = (Get-Date).AddSeconds(20)
  do{
    try{ if((irm "$Base/internal/health" -TimeoutSec 2).ok){ $ok=$true; break } } catch { Start-Sleep -Milliseconds 500 }
  } while((Get-Date) -lt $deadline)

  if($ok){ Write-Host "API OK em $Base" -ForegroundColor Green } else { Write-Host "⚠ Timeout aguardando /internal/health" -ForegroundColor Yellow }
  Write-Host "Dica: logs -> Receive-Job -Name magapi -Keep" -ForegroundColor DarkGray
}
