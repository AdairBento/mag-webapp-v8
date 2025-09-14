# ------------------------------------------------------------
# setup-magwebapp-regex-health_v4.ps1  (REV 2025-09-13)
# - Corrige EPERM (limpa .prisma\client)
# - Upsert tenant 'dev' via arquivo .js
# - Libera porta 3000 automaticamente
# - Insere /internal/health/extended (here-string sem interpolação)
# - **Reescreve** rotas (clients/vehicles/rentals/maintenances) com GET+POST
# - Atualiza MagApi no MyDocuments
# ------------------------------------------------------------

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$VerbosePreference    = 'Continue'

# ---------------- Paths ----------------
$RootDir       = $PWD
$ApiDir        = Join-Path $RootDir 'apps\api'
$SrcDir        = Join-Path $ApiDir  'src'
$IndexFile     = Join-Path $SrcDir  'index.js'

$RoutesDir     = Join-Path $ApiDir 'src\routes'
$ClientsRoute  = Join-Path $RoutesDir 'clients.routes.js'
$VehiclesRoute = Join-Path $RoutesDir 'vehicles.routes.js'
$RentalsRoute  = Join-Path $RoutesDir 'rentals.routes.js'
$MaintRoute    = Join-Path $RoutesDir 'maintenances.routes.js'

$MyDocs        = [Environment]::GetFolderPath('MyDocuments')
$ModFile       = Join-Path $MyDocs 'PowerShell\Modules\MagApi\MagApi.psm1'

# ---------------- Utils ----------------
function Backup($file) {
  if (Test-Path $file) {
    $bak = "$file.bak_$(Get-Date -Format yyyyMMdd_HHmmss)"
    Copy-Item $file $bak -Force
    Write-Verbose "Backup: $bak"
  }
}

function Free-Port([int]$port) {
  $procId = $null
  try {
    $conn = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($conn) { $procId = $conn.OwningProcess }
  } catch { }
  if (-not $procId) {
    $line = (netstat -ano | Select-String -Pattern "LISTENING.*:$port\s") | Select-Object -First 1
    if ($line) { $procId = ($line.ToString().Trim() -split '\s+')[-1] }
  }
  if ($procId) {
    Write-Verbose "Matando processo na porta $port (PID $procId)"
    Stop-Process -Id [int]$procId -Force -ErrorAction SilentlyContinue
  } else {
    Write-Verbose "Nenhum processo escutando na porta $port"
  }
}

function Kill-NodePrisma {
  Get-Process node, prisma -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

function Test-Database {
  Write-Verbose "Verificando conexão com o banco"
  Push-Location $ApiDir
  try {
    $envFile = Join-Path $ApiDir '.env'
    if (-not (Test-Path $envFile)) { throw ".env não encontrado em $ApiDir" }
    $content = Get-Content $envFile -Raw
    if ($content -notmatch 'DATABASE_URL\s*=\s*(.+)') { throw "DATABASE_URL não definido" }
    Write-Verbose "DATABASE_URL: $($matches[1])"
    $psql = Get-Command psql -ErrorAction SilentlyContinue
    if ($psql) {
      $out = & psql -d $matches[1] -c "SELECT 1" 2>&1
      if ($LASTEXITCODE -ne 0) { throw "Falha ao conectar: $out" }
      Write-Verbose "Banco operacional"
    } else {
      Write-Warning "psql não encontrado; pulei teste"
    }
  } catch {
    Write-Error "❌ $($_.Exception.Message)"; exit 1
  } finally { Pop-Location }
}

function Run-Migrations {
  Write-Verbose "Executando migrações Prisma"
  Push-Location $ApiDir
  try {
    Kill-NodePrisma
    # EPERM workaround
    Remove-Item -Recurse -Force (Join-Path $RootDir 'node_modules\.prisma\client') -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force (Join-Path $ApiDir  'node_modules\.prisma\client') -ErrorAction SilentlyContinue

    npx prisma format                | Write-Verbose
    npx prisma migrate reset --force | Write-Verbose
    $name = "setup_regex_v4_$(Get-Date -Format 'yyyyMMddHHmm')"
    npx prisma migrate dev --name $name | Write-Verbose
    npx prisma generate              | Write-Verbose
    Write-Host "✔ Prisma migrado: $name" -ForegroundColor Green
  } catch {
    Write-Error "❌ Erro Prisma: $_"; exit 1
  } finally { Pop-Location }
}

function Ensure-TenantDev {
  Push-Location $ApiDir
  try {
    Write-Verbose "Upsert do tenant 'dev' via arquivo .js"
    $js = @'
const { PrismaClient } = require("@prisma/client");
(async () => {
  const p = new PrismaClient();
  await p.tenant.upsert({
    where:{ id:"dev" },
    update:{ name:"Dev Tenant", domain:"dev.local" },
    create:{ id:"dev", name:"Dev Tenant", domain:"dev.local" }
  });
  console.log("tenant ok");
  await p.$disconnect();
})();
'@
    $tempJs = Join-Path $ApiDir 'ensureTenantDev.js'
    $js | Set-Content -Path $tempJs -Encoding UTF8
    node $tempJs
    if ($LASTEXITCODE -ne 0) { throw 'Falha no upsert do tenant' }
    Remove-Item $tempJs -Force
    $env:MAG_TENANT = 'dev'
  } finally { Pop-Location }
}

# ---------------- Reescrever ROTAS (templates estáveis) ----------------

function Write-ClientsRoute {
  Backup $ClientsRoute
  @'
const express = require("express");
const router  = express.Router();
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// GET /api/v1/clients
router.get("/", async (req, res) => {
  try {
    const { tenantId, email, limit = 100 } = req.query;
    const data = await prisma.client.findMany({
      where: {
        tenantId: tenantId ? String(tenantId) : undefined,
        email:    email ? String(email) : undefined,
      },
      take: parseInt(limit, 10),
      orderBy: { createdAt: "desc" },
    });
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error:"internal_error", message:e.message });
  }
});

// POST /api/v1/clients
router.post("/", async (req, res) => {
  const { tenantId: tId, name, email, phone, document, address } = req.body;
  const id = tId || req.get("x-tenant-id") || req.query.tenantId;
  if (!id)    return res.status(400).json({ error:"bad_request", message:"tenantId required" });
  if (!name)  return res.status(400).json({ error:"bad_request", message:"name required" });
  if (!email) return res.status(400).json({ error:"bad_request", message:"email required" });
  try {
    const data = {
      tenant:   { connect: { id: String(id) } },
      name:     String(name),
      email:    String(email).toLowerCase(),
      phone:    phone ?? null,
      document: document ?? null,
      address:  address ?? null
    };
    const client = await prisma.client.create({ data });
    res.status(201).json({ data: client });
  } catch (e) {
    const code = e.code === "P2002" ? 409 : 500;
    res.status(code).json({ error: code===409?"conflict":"internal_error", message:e.message });
  }
});

module.exports = router;
'@ | Set-Content -Path $ClientsRoute -Encoding UTF8
  Write-Host "✔ Reescrito: clients.routes.js" -ForegroundColor Green
}

function Write-VehiclesRoute {
  Backup $VehiclesRoute
  @'
const express = require("express");
const router  = express.Router();
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// GET /api/v1/vehicles
router.get("/", async (req, res) => {
  try {
    const { tenantId, plate, status, limit = 100 } = req.query;
    const data = await prisma.vehicle.findMany({
      where: {
        tenantId: tenantId ? String(tenantId) : undefined,
        plate:    plate ? String(plate).toUpperCase() : undefined,
        status:   status || undefined
      },
      take: parseInt(limit, 10),
      orderBy: { createdAt: "desc" },
    });
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error:"internal_error", message:e.message });
  }
});

// POST /api/v1/vehicles
router.post("/", async (req, res) => {
  const id = req.body.tenantId || req.get("x-tenant-id") || req.query.tenantId;
  if (!id) return res.status(400).json({ error:"bad_request", message:"tenantId required" });
  if (!req.body.plate) return res.status(400).json({ error:"bad_request", message:"plate required" });
  try {
    const data = {
      tenant:   { connect: { id: String(id) } },
      plate:    String(req.body.plate).toUpperCase(),
      brand:    req.body.brand ?? "Chevrolet",
      model:    req.body.model ?? "Onix",
      year:     parseInt(req.body.year ?? 2022, 10),
      dailyRate:String(req.body.dailyRate ?? "120.00"),
      status:   req.body.status ?? "available",
      color:    req.body.color ?? "Prata",
      fuelType: req.body.fuelType ?? "Flex",
      category: req.body.category ?? "Hatch"
    };
    const created = await prisma.vehicle.create({ data });
    res.status(201).json({ data: created });
  } catch (e) {
    const code = e.code === "P2002" ? 409 : 400;
    res.status(code).json({ error: code===409?"conflict":"bad_request", message:e.message });
  }
});

module.exports = router;
'@ | Set-Content -Path $VehiclesRoute -Encoding UTF8
  Write-Host "✔ Reescrito: vehicles.routes.js" -ForegroundColor Green
}

function Write-RentalsRoute {
  Backup $RentalsRoute
  @'
const express = require("express");
const router  = express.Router();
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// GET /api/v1/rentals
router.get("/", async (req, res) => {
  try {
    const { tenantId, vehicleId, clientId, status, limit = 100 } = req.query;
    const data = await prisma.rental.findMany({
      where: {
        tenantId: tenantId ? String(tenantId) : undefined,
        vehicleId: vehicleId ? String(vehicleId) : undefined,
        clientId:  clientId ? String(clientId) : undefined,
        status: status || undefined
      },
      take: parseInt(limit, 10),
      orderBy: { startDate: "desc" },
    });
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error:"internal_error", message:e.message });
  }
});

// POST /api/v1/rentals
router.post("/", async (req, res) => {
  const id = req.body.tenantId || req.get("x-tenant-id") || req.query.tenantId;
  const { vehicleId, clientId, startDate, endDate, dailyRate, status } = req.body;
  if (!id)        return res.status(400).json({ error:"bad_request", message:"tenantId required" });
  if (!vehicleId) return res.status(400).json({ error:"bad_request", message:"vehicleId required" });
  if (!clientId)  return res.status(400).json({ error:"bad_request", message:"clientId required" });
  if (!startDate) return res.status(400).json({ error:"bad_request", message:"startDate required" });
  if (!endDate)   return res.status(400).json({ error:"bad_request", message:"endDate required" });
  try {
    const data = {
      tenant:   { connect: { id: String(id) } },
      vehicle:  { connect: { id: String(vehicleId) } },
      client:   { connect: { id: String(clientId) } },
      startDate: new Date(startDate),
      endDate:   new Date(endDate),
      dailyRate: String(dailyRate ?? "120.00"),
      status:    status ?? "confirmed"
    };
    const created = await prisma.rental.create({ data });
    res.status(201).json({ data: created });
  } catch (e) {
    res.status(400).json({ error:"bad_request", message:e.message });
  }
});

module.exports = router;
'@ | Set-Content -Path $RentalsRoute -Encoding UTF8
  Write-Host "✔ Reescrito: rentals.routes.js" -ForegroundColor Green
}

function Write-MaintenancesRoute {
  Backup $MaintRoute
  @'
const express = require("express");
const router  = express.Router();
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// GET /api/v1/maintenances
router.get("/", async (req, res) => {
  try {
    const { tenantId, vehicleId, status, limit = 100 } = req.query;
    const data = await prisma.maintenance.findMany({
      where: {
        tenantId: tenantId ? String(tenantId) : undefined,
        vehicleId: vehicleId ? String(vehicleId) : undefined,
        status: status || undefined
      },
      take: parseInt(limit, 10),
      orderBy: { startDate: "desc" },
    });
    res.json({ data });
  } catch (e) {
    res.status(500).json({ error:"internal_error", message:e.message });
  }
});

// POST /api/v1/maintenances
router.post("/", async (req, res) => {
  const id = req.body.tenantId || req.get("x-tenant-id") || req.query.tenantId;
  const { vehicleId, description, startDate, endDate, status } = req.body;
  if (!id)          return res.status(400).json({ error:"bad_request", message:"tenantId required" });
  if (!vehicleId)   return res.status(400).json({ error:"bad_request", message:"vehicleId required" });
  if (!description) return res.status(400).json({ error:"bad_request", message:"description required" });
  if (!startDate)   return res.status(400).json({ error:"bad_request", message:"startDate required" });
  try {
    const data = {
      tenant:      { connect: { id: String(id) } },
      vehicle:     { connect: { id: String(vehicleId) } },
      description: String(description),
      startDate:   new Date(startDate),
      endDate:     endDate ? new Date(endDate) : null,
      status:      status ?? "scheduled"
    };
    const created = await prisma.maintenance.create({ data });
    res.status(201).json({ data: created });
  } catch (e) {
    res.status(400).json({ error:"bad_request", message:e.message });
  }
});

module.exports = router;
'@ | Set-Content -Path $MaintRoute -Encoding UTF8
  Write-Host "✔ Reescrito: maintenances.routes.js" -ForegroundColor Green
}

# ---------------- /internal/health/extended ----------------
function Ensure-HealthExtended {
  if (-not (Test-Path $IndexFile)) { Write-Warning "index.js não encontrado: $IndexFile"; return }
  $js = Get-Content $IndexFile -Raw -Encoding UTF8
  if ($js -match '/internal/health/extended') { Write-Verbose "extended já existe"; return }

  $block = @'
const startTs = Date.now();
app.get("/internal/health/extended", async (req, res) => {
  try {
    const { PrismaClient } = require("@prisma/client");
    const prisma = global.__prisma || new PrismaClient();
    if (!global.__prisma) global.__prisma = prisma;
    await prisma.$queryRaw`SELECT 1`;
    res.json({
      status: "ok",
      timestamp: new Date().toISOString(),
      uptime_ms: Date.now() - startTs,
      checks: { system: "ok", database: "ok" }
    });
  } catch (e) {
    res.status(500).json({
      status: "error",
      message: e?.message || String(e),
      checks: { system: "ok", database: "error" }
    });
  }
});
'@

  Backup $IndexFile
  if ($js -match 'app\.listen\s*\(') {
    $patched = $js -replace '(?s)(?=app\.listen\s*\()', ($block + "`r`n")
  } else {
    $patched = $js.TrimEnd() + "`r`n`r`n// inserted by setup v4`r`n" + $block
  }
  Set-Content $IndexFile -Value $patched -Encoding UTF8
  Write-Host "✔ /internal/health/extended inserido no index.js" -ForegroundColor Green
}

# --------------- MagApi.psm1 ---------------
function Fix-MagApi {
  Write-Verbose "Patch MagApi.psm1"
  New-Item -ItemType Directory -Force (Split-Path $ModFile -Parent) | Out-Null
  Backup $ModFile

  $modContent = @'
# MagApi - PowerShell Module para interagir com sua API

# Base e Tenant
if (! $script:MAG_BASE)   { $script:MAG_BASE   = $env:MAG_BASE   ?? "http://localhost:3000" }
if (! $script:MAG_TENANT) { $script:MAG_TENANT = $env:MAG_TENANT ?? "dev" }
if (! $Tenant)            { $Tenant            = $script:MAG_TENANT }

function As-Array { param($v) if ($null -eq $v) { @() } elseif ($v -is [array]) { $v } else { @($v) } }

function GetJson {
  param(
    [Parameter(Mandatory=$true)][string]$Path,
    [ValidateSet("GET","POST","PUT","PATCH","DELETE")][string]$Method="GET",
    $Body=$null,
    [hashtable]$Headers=$null
  )
  $base = $script:MAG_BASE
  $uri  = if ($Path -match "^https?://") { $Path } else { $base.TrimEnd('/') + $Path }
  $h    = @{}
  if ($Headers)    { $h += $Headers }
  if ($Tenant)     { $h['X-Tenant-Id']  = "$Tenant" }
  if ($AuthToken)  { $h['Authorization'] = "Bearer $AuthToken" }
  $p = @{ Uri = $uri; Method = $Method; Headers = $h; ContentType = 'application/json' }
  if ($Body) { $p.Body = ($Body | ConvertTo-Json -Depth 10 -Compress) }
  try { Invoke-RestMethod @p } catch { throw "API Error $uri : $($_.Exception.Message)" }
}

function Ensure-Client {
  param($email,[string]$name)
  $qs    = @("tenantId=$Tenant","email=$([uri]::EscapeDataString($email))")
  $found = As-Array ((GetJson "/api/v1/clients?$( $qs -join '&' )").data)
  if ($found.Count) { $found[0] } else { (GetJson "/api/v1/clients" -Method POST -Body @{ tenantId=$Tenant; email=$email; name=$name }).data }
}

function Get-RentalsByStatus {
  param([string]$status,[int]$limit=200,[string]$vehicleId='')
  $pairs = @()
  if ($Tenant)    { $pairs += "tenantId=$Tenant" }
  if ($status)    { $pairs += "status=$status" }
  if ($vehicleId) { $pairs += "vehicleId=$vehicleId" }
  $pairs += "limit=$limit"
  As-Array ((GetJson "/api/v1/rentals?$( $pairs -join '&' )").data)
}

function Show-RentalStatus {
  param([string]$vehicleId,[string[]]$OnlyStatuses=@())
  $all = Get-RentalsByStatus -status '' -limit 200 -vehicleId $vehicleId
  if ($OnlyStatuses.Count) { $all = $all | Where-Object { $OnlyStatuses -contains $_.status } }
  if (-not $all.Count) { Write-Host "Nenhuma locação para $vehicleId" -ForegroundColor Yellow }
  else { $all | Format-Table id, status, startDate, endDate -AutoSize }
}

function Mag-Boot {
  Write-Host "🔧 Criando dados de teste..." -ForegroundColor Cyan
  # Cliente
  $c = (GetJson "/api/v1/clients?tenantId=$Tenant&limit=1").data | Select-Object -First 1
  if (-not $c) { $c = (GetJson "/api/v1/clients" -Method POST -Body @{ tenantId=$Tenant; name="Cliente Teste"; email="cliente.teste@example.com" }).data }
  # Veículo
  $v = (GetJson "/api/v1/vehicles?tenantId=$Tenant&limit=1").data | Select-Object -First 1
  if (-not $v) {
    $v = (GetJson "/api/v1/vehicles" -Method POST -Body @{
      tenantId=$Tenant; plate="ABC-0001"; brand="Chevrolet"; model="Onix"; year=2022; dailyRate="120.00"; status="available"
    }).data
  }
  # Locação confirmada
  $r = Get-RentalsByStatus -status "confirmed" -vehicleId $v.id
  if (-not $r.Count) {
    $s = Get-Date; $e = $s.AddDays(3)
    (GetJson "/api/v1/rentals" -Method POST -Body @{
      tenantId  = $Tenant; vehicleId = $v.id; clientId  = $c.id
      startDate = $s.ToString("o"); endDate = $e.ToString("o")
      dailyRate = "120.00"; status= "confirmed"
    }).data
  }
  Write-Host "🎉 Dados de teste criados! VehicleId: $($v.id)" -ForegroundColor Green
}

function Initialize-Maintenance {
  param($vehicleId,[string]$description,[int]$days=1)
  $qs    = @("tenantId=$Tenant","vehicleId=$vehicleId","status=scheduled","limit=1")
  $found = As-Array ((GetJson "/api/v1/maintenances?$( $qs -join '&' )").data)
  if ($found.Count) { Write-Host "Manutenção já existe: $description" -ForegroundColor Gray; return $found[0] }
  Write-Host "Criando manutenção: $description" -ForegroundColor Yellow
  $s = Get-Date; $e = $s.AddDays($days)
  (GetJson "/api/v1/maintenances" -Method POST -Body @{
    tenantId=$Tenant; vehicleId=$vehicleId; description=$description
    startDate=$s.ToString("o"); endDate=$e.ToString("o"); status="scheduled"
  }).data
}

Export-ModuleMember -Function *
'@

  Set-Content $ModFile -Value $modContent -Encoding UTF8
  Remove-Module MagApi -ErrorAction SilentlyContinue
  Import-Module $ModFile -Force -DisableNameChecking -Verbose
  Write-Host "✔ MagApi.psm1 atualizado e recarregado de: $ModFile" -ForegroundColor Green
}

# ---------------- Execução ----------------
try {
  Test-Database

  Kill-NodePrisma
  Free-Port -port 3000

  Run-Migrations
  Ensure-TenantDev

  # Rotas reescritas (sem regex)
  Write-ClientsRoute
  Write-VehiclesRoute
  Write-RentalsRoute
  Write-MaintenancesRoute

  Ensure-HealthExtended
  Fix-MagApi

  Write-Host "`n✅ Setup v4 concluído!" -ForegroundColor White
  Write-Host "1) cd apps/api && npm run dev" -ForegroundColor Cyan
  Write-Host "2) `$env:MAG_TENANT='dev'" -ForegroundColor Cyan
  Write-Host "3) Import-Module `"$($ModFile)`" -Force" -ForegroundColor Cyan
  Write-Host "4) Mag-Boot  (gera cliente/veículo/locação)" -ForegroundColor Cyan
  Write-Host "5) irm http://localhost:3000/internal/health  e  /internal/health/extended" -ForegroundColor Cyan
} catch {
  Write-Error "❌ Falha no setup: $_"; exit 1
}
