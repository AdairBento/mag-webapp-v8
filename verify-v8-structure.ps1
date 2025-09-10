# verify-v8-structure.ps1
param(
  [string]$Root    = (Get-Location).Path,
  [string]$Base    = 'http://localhost:3000',
  [int]   $Port    = 3000,
  [string]$Tenant  = '',
  [switch]$Start,          # se informado, tenta subir a API e checar
  [switch]$StopAfter       # se subiu aqui, derruba no fim
)

# ---- ui helpers
function OK($m){   Write-Host "✅ $m" -ForegroundColor Green }
function WARN($m){ Write-Host "⚠️  $m" -ForegroundColor Yellow }
function ERR($m){  Write-Host "❌ $m" -ForegroundColor Red }
function INFO($m){ Write-Host "ℹ️  $m" -ForegroundColor Cyan }

# ---- join de URL
function UrlJoin([string]$a,[string]$b){
  ($a.TrimEnd('/')) + '/' + ($b.TrimStart('/'))
}

# ---- testador genérico de endpoint GET
function Test-Endpoint([string]$url,[string]$desc){
  try{
    Write-Host "   → GET $url" -ForegroundColor DarkGray
    $res = Invoke-RestMethod -Uri $url -Method GET -TimeoutSec 10 -ErrorAction Stop
    OK "$desc OK"
    return @{ ok=$true; data=$res }
  }catch{
    ERR "$desc FAIL: $($_.Exception.Message)"
    return @{ ok=$false; err=$_.Exception.Message }
  }
}

# ---- start/stop API (auto-health check)
function Start-Api([int]$p){
  $env:PORT = $p
  $out = "api.$p.out.log"; $err = "api.$p.err.log"
  if(Test-Path $out){ Remove-Item $out -Force }
  if(Test-Path $err){ Remove-Item $err -Force }
  $proc = Start-Process node -ArgumentList 'apps/api/src/index.js' -PassThru `
          -RedirectStandardOutput $out -RedirectStandardError $err
  foreach($i in 1..20){
    try{
      $h = Invoke-RestMethod -Uri "http://localhost:$p/internal/health" -TimeoutSec 1 -ErrorAction Stop
      if($h.status -eq 'ok'){ OK "API UP na $p"; return $proc }
    }catch{ Start-Sleep -Milliseconds 500 }
  }
  ERR "API não subiu; mostrando tail dos logs:"
  if(Test-Path $err){ Get-Content $err -Tail 80 } elseif(Test-Path $out){ Get-Content $out -Tail 80 }
  return $null
}

function Stop-ByProcessId([int]$ProcessId){
  try{ Stop-Process -Id $ProcessId -Force; WARN "Parado PID=$ProcessId" }catch{
    WARN "Falha ao parar PID=${ProcessId}: $($_.Exception.Message)"
  }
}

# ---- validação do Base
$Base = ($Base ?? '').Trim('"').Trim()
if(-not $Base.StartsWith('http')){
  $Base = 'http://' + $Base
}
try{
  [void]([uri]$Base)
}catch{
  ERR "Base inválida: '$Base'"
  exit 1
}

Write-Host ""
Write-Host "🔍 Verificando estrutura v8 em: $Root" -ForegroundColor Magenta
Write-Host "Base: $Base  | Port: $Port  | Tenant: $Tenant" -ForegroundColor DarkGray

# ---- 1) Estrutura de diretórios e arquivos
$requiredDirs = @(
  'apps/api/src',
  'apps/api/src/routes',
  'apps/api/src/controllers',
  'apps/api/src/services',
  'apps/api/src/repositories',
  'apps/api/src/middlewares',
  'apps/api/src/utils',
  'scripts',
  'docs'
)

$requiredFiles = @(
  'apps/api/src/index.js',
  'apps/api/src/routes/health.routes.js',
  'apps/api/src/routes/clients.routes.js',
  'apps/api/src/routes/vehicles.routes.js',
  'apps/api/src/routes/rentals.routes.js',
  'apps/api/src/routes/availability.routes.js',
  'scripts/generate-openapi.cjs',
  'package.json',
  'start-api.ps1',
  'stop-api.ps1',
  'smoke-mag-api-check.ps1',
  'smoke-mag-api-idempotente.ps1'
)

$missing = @()
Write-Host "`n1) Estrutura de pastas" -ForegroundColor Magenta
foreach($d in $requiredDirs){
  $path = Join-Path $Root $d
  if(Test-Path $path -PathType Container){ OK "dir: $d" } else { ERR "dir: $d (faltando)"; $missing += "dir:$d" }
}

Write-Host "`n2) Arquivos chave" -ForegroundColor Magenta
foreach($f in $requiredFiles){
  $path = Join-Path $Root $f
  if(Test-Path $path -PathType Leaf){ OK "file: $f" } else { ERR "file: $f (faltando)"; $missing += "file:$f" }
}

# ---- 3) package.json (scripts e deps)
Write-Host "`n3) package.json (scripts/deps)" -ForegroundColor Magenta
$pkgPath = Join-Path $Root 'package.json'
if(Test-Path $pkgPath){
  try{
    $pkg = Get-Content $pkgPath -Raw | ConvertFrom-Json
    $needScripts = @('lint','format','test','coverage','docs:openapi','docs:jsdoc','audit:deps','audit:licenses','load','audit')
    foreach($s in $needScripts){
      if($pkg.scripts.$s){ OK "script: $s" } else { WARN "script ausente: $s" }
    }
    $needDeps = @('express')
    $needDevDeps = @('swagger-jsdoc','swagger-ui-express','eslint','prettier','jest','nyc','artillery','license-checker')
    foreach($d in $needDeps){
      if($pkg.dependencies.$d){ OK "dep: $d" } else { WARN "dep ausente: $d" }
    }
    foreach($d in $needDevDeps){
      if($pkg.devDependencies.$d){ OK "devDep: $d" } else { WARN "devDep ausente: $d" }
    }
  }catch{
    ERR "Falha lendo package.json: $($_.Exception.Message)"
  }
}else{
  ERR "package.json não encontrado"
}

# ---- 4) (opcional) start + endpoints
$startedHere = $false
$proc = $null
if($Start){
  # já tem algo escutando?
  $listening = $false
  try{
    $listening = (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue) -ne $null
  }catch{ $listening = $false }
  if(-not $listening){
    $proc = Start-Api $Port
    if($proc){ $startedHere = $true }
  }else{
    INFO "Já há algo escutando em $Port — não vou subir outro processo."
  }

  Write-Host "`n4) Endpoints" -ForegroundColor Magenta
  $h = Test-Endpoint (UrlJoin $Base 'internal/health') 'Health interno'
  if($Tenant){
    [void](Test-Endpoint (UrlJoin $Base "api/v1/clients?tenantId=$Tenant&page=1&limit=5") 'Clients')
    [void](Test-Endpoint (UrlJoin $Base "api/v1/vehicles?tenantId=$Tenant&page=1&limit=5") 'Vehicles')
    [void](Test-Endpoint (UrlJoin $Base "api/v1/rentals?tenantId=$Tenant&page=1&limit=5")  'Rentals')
  }else{
    WARN "Tenant não informado — pulando testes /api/v1/*"
  }
}

# ---- 5) resumo
Write-Host "`n📊 RESUMO" -ForegroundColor Magenta
if($missing.Count -eq 0){ OK "Estrutura OK" } else {
  ERR ("Itens faltando: " + ($missing -join ', '))
}

if($Start -and $startedHere -and $StopAfter -and $proc){
  Stop-ByProcessId -ProcessId $proc.Id
}

if($missing.Count -eq 0){ exit 0 } else { exit 1 }
