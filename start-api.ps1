param([int]$Port = 3000)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Start-Api([int]$port) {
  $env:PORT = $port
  $out = "api.$port.out.log"
  $err = "api.$port.err.log"
  if (Test-Path $out) { Remove-Item $out -Force }
  if (Test-Path $err) { Remove-Item $err -Force }

  $p = Start-Process node -ArgumentList 'apps/api/src/index.js' -PassThru `
       -RedirectStandardOutput $out -RedirectStandardError $err

  # aguarda até ~10s
  for ($i=0; $i -lt 20; $i++) {
    try {
      $h = Invoke-RestMethod -Uri "http://localhost:$port/internal/health" -TimeoutSec 1 -ErrorAction Stop
      if ($h.status -eq 'ok') {
        Write-Host "✅ API UP na $port ($(Get-Date -Format T))" -ForegroundColor Green
        return $p
      }
    } catch { Start-Sleep -Milliseconds 500 }
  }

  Write-Host "❌ API não subiu. Logs (últimas linhas):" -ForegroundColor Red
  if (Test-Path $err) { Get-Content $err -Tail 50 }
  elseif (Test-Path $out) { Get-Content $out -Tail 50 }
  return $null
}

Start-Api -port $Port
