<#  ──────────────────────────────────────────────────────────────────────────
    smoke.ps1 — Smoke test assertivo p/ mag-webapp-v8 (versão com envelope)
    - Health check
    - Cria Client, Vehicle e Rental com asserts (aceita {id} ou {data:{id}})
    - Lista Rentals se a rota existir
─────────────────────────────────────────────────────────────────────────── #>

[CmdletBinding()]
param(
  [string]$Base = "http://localhost:3000",
  [string]$Tenant = "dev",

  # Endpoints (ajuste se preciso)
  [string]$HealthPath       = "/internal/health",
  [string]$HealthExtPath    = "/internal/health/extended",
  [string]$ClientsPath      = "/api/v1/clients",
  [string]$VehiclesPath     = "/api/v1/vehicles",
  [string]$RentalsPath      = "/api/v1/rentals",

  [int]$Days = 1,
  [string]$Status = "pending",

  [switch]$LogToFile,
  [switch]$Quiet
)

# ── Log opcional ───────────────────────────────────────────────────────────
if ($LogToFile) {
  $logFile = "smoke_$((Get-Date).ToString('yyyyMMdd_HHmmss')).log"
  Start-Transcript -Path $logFile -Force | Out-Null
}

# ── Helpers ────────────────────────────────────────────────────────────────
function W([string]$msg) { if (-not $Quiet) { Write-Host $msg } }

function Url([string]$rel) {
  if (-not $Base) { throw "Base não definida." }
  return "$($Base.TrimEnd('/'))/$($rel.TrimStart('/'))"
}

function Merge-Headers([hashtable]$extra) {
  $h = @{}
  if ($Tenant -and $Tenant.Trim().Length -gt 0) { $h['x-tenant-id'] = $Tenant }
  if ($extra) { $extra.GetEnumerator() | ForEach-Object { $h[$_.Key] = $_.Value } }
  return $h
}

function Extract-Id {
  param($resp)
  if (-not $resp) { return $null }
  if ($resp.id) { return $resp.id }
  if ($resp.data -and $resp.data.id) { return $resp.data.id }
  if ($resp.result -and $resp.result.id) { return $resp.result.id }
  if ($resp.item -and $resp.item.id) { return $resp.item.id }
  if ($resp.data -and $resp.data -is [System.Array] -and $resp.data.Length -gt 0 -and $resp.data[0].id) { return $resp.data[0].id }
  if ($resp.items -and $resp.items -is [System.Array] -and $resp.items.Length -gt 0 -and $resp.items[0].id) { return $resp.items[0].id }
  return $null
}

function Assert-HasId($obj, [string]$entityName) {
  $id = Extract-Id $obj
  if (-not $id) {
    $json = try { $obj | ConvertTo-Json -Depth 8 } catch { "$obj" }
    throw "[$entityName] sem 'id' no retorno. Body: $json"
  }
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
  if (-not [uri]::IsWellFormedUriString($uri, [System.UriKind]::Absolute)) { throw "URI inválido: $uri" }

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
    $resp = $_.Exception.Response
    if ($resp -and $resp.GetResponseStream) {
      $reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
      $text = $reader.ReadToEnd()
      throw "Falha em $Method $uri — $($_.Exception.Message)`nBody: $text"
    } else {
      throw "Falha em $Method $uri — $($_.Exception.Message)"
    }
  }
}

# ── Ações de domínio ───────────────────────────────────────────────────────
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
  $id = Extract-Id $resp
  W "✓ Client criado: $id"
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
  $id = Extract-Id $resp
  W "✓ Vehicle criado: $id"
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
  $id = Extract-Id $resp
  W "✓ Rental criado: $id"
  return $resp
}

function List-Rentals {
  param([string]$Status)
  $path = $RentalsPath
  if ($Status) { $path = "$RentalsPath?status=$([uri]::EscapeDataString($Status))" }
  W "→ Listando Rentals (status=$Status)..."
  try {
    return Invoke-Api -Method Get -Path $path
  } catch {
    if ($_.Exception.Message -match 'Cannot GET' -or $_.Exception.Message -match '\(404\)') {
      W "⚠ GET $path não implementado na API. Pulando listagem."
      return $null
    }
    throw
  }
}

# ── Execução ───────────────────────────────────────────────────────────────
W "== Smoke test (Base=$Base, Tenant=$Tenant, Days=$Days, Status=$Status) =="

# Health
try {
  $h1 = Invoke-Api -Method Get -Path $HealthExtPath
  W "✓ Health extended ok: $($h1.status) — uptime_ms=$($h1.uptime_ms)"
} catch {
  W "⚠ Extended falhou, tentando health simples… ($_)"
  $h0 = Invoke-Api -Method Get -Path $HealthPath
  W "✓ Health ok: $($h0.status)"
}

# Create
$c = New-Client
$v = New-Vehicle
$r = New-Rental -ClientId (Extract-Id $c) -VehicleId (Extract-Id $v) -Days $Days -Status $Status

# List
$lst = List-Rentals -Status $Status
if ($lst) {
  if ($lst.data) { W ("✓ Rentals encontrados: " + ($lst.data | Measure-Object).Count) }
  elseif ($lst.items) { W ("✓ Rentals encontrados: " + ($lst.items | Measure-Object).Count) }
  elseif ($lst -is [System.Array]) { W ("✓ Rentals encontrados: " + $lst.Count) }
  else { W "✓ Rentals listados." }
} else {
  W "ℹ Sem listagem de rentals (rota ausente ou vazia)."
}

W "== Fim do smoke =="
if ($LogToFile) { Stop-Transcript | Out-Null }
