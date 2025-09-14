<#  ──────────────────────────────────────────────────────────────────────────
    smoke.ps1 — Smoke test assertivo p/ mag-webapp-v8
    - Faz health check
    - Cria Client, Vehicle e Rental com asserts (falha se faltar "id")
    - Lista Rentals (com filtro -Status)
    Como usar:
      .\smoke.ps1
      .\smoke.ps1 -Days 2 -Verbose
      .\smoke.ps1 -Base http://localhost:3001 -Tenant 022d0c59-4363-4993-a485-9adf29719824 -LogToFile
─────────────────────────────────────────────────────────────────────────── #>

[CmdletBinding()]
param(
  [string]$Base = "http://localhost:3000",
  [string]$Tenant = "dev",

  # Endpoints padrão (ajustáveis conforme sua API)
  [string]$HealthPath       = "/internal/health",
  [string]$HealthExtPath    = "/internal/health/extended",
  [string]$ClientsPath      = "/api/clients",
  [string]$VehiclesPath     = "/api/vehicles",
  [string]$RentalsPath      = "/api/rentals",

  [int]$Days = 1,
  [string]$Status = "pending",

  [switch]$LogToFile,
  [switch]$Quiet
)

# ── Setup de log opcional ──────────────────────────────────────────────────
if ($LogToFile) {
  $logFile = "smoke_$((Get-Date).ToString('yyyyMMdd_HHmmss')).log"
  Start-Transcript -Path $logFile -Force | Out-Null
}

# ── Helpers ────────────────────────────────────────────────────────────────
function W([string]$msg) { if (-not $Quiet) { Write-Host $msg } }

function Url([string]$rel) {
  if (-not $Base) { throw "Base não definida." }
  $b = $Base.TrimEnd('/')
  $r = $rel.TrimStart('/')
  return "$b/$r"
}

function Merge-Headers([hashtable]$extra) {
  $h = @{}
  if ($Tenant) { $h['x-tenant-id'] = $Tenant }
  if ($extra) { $extra.GetEnumerator() | ForEach-Object { $h[$_.Key] = $_.Value } }
  return $h
}

function Invoke-Api {
  param(
    [ValidateSet('Get','Post','Patch','Put','Delete')] [string]$Method = 'Get',
    [Parameter(Mandatory)][string]$Path,
    [hashtable]$Headers = @{},
    [string]$ContentType = 'application/json',
    $Body
  )
  $uri = Url $Path
  if (-not [uri]::IsWellFormedUriString($uri, [System.UriKind]::Absolute)) {
    throw "URI inválido: $uri"
  }
  $params = @{
    Method  = $Method
    Uri     = $uri
    Headers = (Merge-Headers $Headers)
  }
  if ($Body) {
    $params.ContentType = $ContentType
    $params.Body = ($Body -is [string]) ? $Body : ($Body | ConvertTo-Json -Depth 8)
  }
  try {
    return Invoke-RestMethod @params
  } catch {
    throw "Falha em $Method $uri — $($_.Exception.Message)"
  }
}

function Assert-HasId($obj, [string]$entityName) {
  if (-not $obj)       { throw "[$entityName] vazio/nulo." }
  if (-not $obj.id)    { throw "[$entityName] sem 'id' no retorno." }
}

# ── Ações de domínio (ajuste payloads conforme sua API) ────────────────────
function New-Client {
  $payload = @{
    name        = "Cliente Smoke $([Guid]::NewGuid().ToString('N').Substring(0,6))"
    document    = "00000000000"
    email       = "smoke+$((Get-Date).ToString('yyyyMMddHHmmss'))@example.com"
    phone       = "(31) 99999-0000"
  }
  W "→ Criando Client..."
  $resp = Invoke-Api -Method Post -Path $ClientsPath -Body $payload
  Assert-HasId $resp "Client"
  W "✓ Client criado: $($resp.id)"
  return $resp
}

function New-Vehicle {
  $payload = @{
    plate       = "SMK$([int](Get-Random -Minimum 1000 -Maximum 9999))"
    model       = "Smoke Test"
    brand       = "MAG"
    year        = 2024
    status      = "available"
  }
  W "→ Criando Vehicle..."
  $resp = Invoke-Api -Method Post -Path $VehiclesPath -Body $payload
  Assert-HasId $resp "Vehicle"
  W "✓ Vehicle criado: $($resp.id)"
  return $resp
}

function New-Rental {
  param([string]$ClientId, [string]$VehicleId, [int]$Days = 1, [string]$Status = "pending")
  $start = (Get-Date).ToString("yyyy-MM-dd")
  $end   = (Get-Date).AddDays($Days).ToString("yyyy-MM-dd")
  $payload = @{
    clientId   = $ClientId
    vehicleId  = $VehicleId
    startDate  = $start
    endDate    = $end
    status     = $Status
    notes      = "Smoke rental ($Days dia[s])"
  }
  W "→ Criando Rental ($start → $end, status=$Status)..."
  $resp = Invoke-Api -Method Post -Path $RentalsPath -Body $payload
  Assert-HasId $resp "Rental"
  W "✓ Rental criado: $($resp.id)"
  return $resp
}

function List-Rentals {
  param([string]$Status)
  $path = $RentalsPath
  if ($Status) { $path = "$RentalsPath?status=$([uri]::EscapeDataString($Status))" }
  W "→ Listando Rentals (status=$Status)..."
  $resp = Invoke-Api -Method Get -Path $path
  return $resp
}

# ── Execução ───────────────────────────────────────────────────────────────
W "== Smoke test (Base=$Base, Tenant=$Tenant, Days=$Days, Status=$Status) =="

# 1) Health checks (tenta o extended, cai para o simples se falhar)
try {
  $h1 = Invoke-Api -Method Get -Path $HealthExtPath
  W "✓ Health extended ok: $($h1.status) — uptime_ms=$($h1.uptime_ms)"
} catch {
  W "⚠ Extended falhou, tentando health simples… ($_)"
  $h0 = Invoke-Api -Method Get -Path $HealthPath
  W "✓ Health ok: $($h0.status)"
}

# 2) Create Client & Vehicle
$c = New-Client
$v = New-Vehicle

# 3) Create Rental (assertivo)
$r = New-Rental -ClientId $c.id -VehicleId $v.id -Days $Days -Status $Status

# 4) Listagem final
$lst = List-Rentals -Status $Status
if ($lst -is [System.Array]) {
  W ("✓ Rentals encontrados: " + $lst.Count)
} elseif ($lst) {
  # algumas APIs retornam objeto { data = [...] ; count = N }
  if ($lst.data) { W ("✓ Rentals encontrados: " + ($lst.data | Measure-Object).Count) }
  elseif ($lst.items) { W ("✓ Rentals encontrados: " + ($lst.items | Measure-Object).Count) }
  else { W "✓ Rentals listados." }
} else {
  W "⚠ Nenhum rental retornado (verifique o filtro de status)."
}

W "== Fim do smoke =="
if ($LogToFile) { Stop-Transcript | Out-Null }
