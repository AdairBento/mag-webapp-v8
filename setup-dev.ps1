# scripts/setup-dev.ps1
param(
  [string]$PkgPath = "apps/api/package.json",
  [string]$ApiDir  = "apps/api",
  [int]$Port = 3001
)

Write-Host "==> Carregando $PkgPath ..."
if (-not (Test-Path $PkgPath)) {
  throw "Arquivo não encontrado: $PkgPath"
}

# 1) Backup com timestamp
$backup = "$PkgPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item $PkgPath $backup -Force
Write-Host "Backup criado: $backup"

# 2) Ler package.json
$json = Get-Content $PkgPath -Raw | ConvertFrom-Json

# 3) Garantir 'scripts' como objeto
if (-not $json.scripts) {
  $json | Add-Member -NotePropertyName scripts -NotePropertyValue ([pscustomobject]@{}) -Force
}

# 4) Helper para definir chave com ':' em PSCustomObject
function Set-JsonScript {
  param([string]$Name, [string]$Value)
  $props = $json.scripts.PSObject.Properties
  $existing = $props | Where-Object { $_.Name -eq $Name }
  if ($existing) { $existing.Value = $Value } else { $json.scripts | Add-Member -NotePropertyName $Name -NotePropertyValue $Value -Force }
}

# 5) Definir/atualizar script start:dev:3001 (usa cross-env)
$scriptValue = "cross-env PORT=$Port node src/index.js"
Set-JsonScript -Name 'start:dev:3001' -Value $scriptValue
Write-Host "Script 'start:dev:3001' configurado: $scriptValue"

# 6) Salvar package.json formatado
$json | ConvertTo-Json -Depth 30 | Set-Content $PkgPath -Encoding UTF8
Write-Host "package.json salvo."

# 7) Verificar/instalar cross-env
Write-Host "==> Verificando cross-env..."
$needInstall = $true
try {
  $pkgLock = Join-Path $ApiDir "package-lock.json"
  if (Test-Path $pkgLock) {
    $lock = Get-Content $pkgLock -Raw
    if ($lock -match '"cross-env"') { $needInstall = $false }
  }
} catch {}

if ($needInstall) {
  Write-Host "Instalando cross-env (devDependency)..."
  npm --prefix $ApiDir install -D cross-env
} else {
  Write-Host "cross-env já presente (lock detectado)."
}

# 8) Subir API na porta desejada
Write-Host "==> Iniciando API em http://localhost:$Port ..."
npm --prefix $ApiDir run start:dev:3001
