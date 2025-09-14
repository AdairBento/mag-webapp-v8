# ------------------------------------------------------------
# setup-magwebapp-regex-health.ps1  (REV 2025-09-13)
# - Patches por REGEX: substitui apenas o bloco router.post('/')
# - Preserva os demais endpoints/linhas das rotas
# - Garante tenant 'dev' via Prisma
# - Atualiza módulo MagApi com correções
# - Cria endpoint /internal/health/extended no index.js (sem quebrar o resto)
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

$ModFile       = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\Modules\MagApi\MagApi.psm1'

# ---------------- Utils ----------------
function Backup($file) {
  if (Test-Path $file) {
    $bak = "$file.bak_$(Get-Date -Format yyyyMMdd_HHmmss)"
    Copy-Item $file $bak -Force
    Write-Verbose "Backup: $bak"
  }
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

function Stop-PrismaStudio {
  Write-Verbose "Parando Prisma Studio (se houver)"
  Get-Process -Name "prisma" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

function Run-Migrations {
  Write-Verbose "Executando migrações Prisma"
  Push-Location $ApiDir
  try {
    npx prisma format                | Write-Verbose
    npx prisma migrate reset --force | Write-Verbose   # ⚠️ zera DB (ok para DEV)
    $name = "setup_regex_$(Get-Date -Format 'yyyyMMddHHmm')"
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
    Write-Verbose "Upsert do tenant 'dev' via Prisma"
    node -e "const {PrismaClient}=require('@prisma/client');(async()=>{const p=new PrismaClient();await p.tenant.upsert({where:{id:'dev'},update:{name:'Dev Tenant',domain:'dev.local'},create:{id:'dev',name:'Dev Tenant',domain:'dev.local'}});console.log('tenant ok');await p.$disconnect()})();"
    if($LASTEXITCODE -ne 0){ throw 'Falha no upsert do tenant' }
    $env:MAG_TENANT = 'dev'
  } finally { Pop-Location }
}

# ---------------- Patch por REGEX (rotas) ----------------
$PostPattern = '(?s)router\.post\s*\(\s*[''"]\/[''"]\s*,\s*async\s*\(\s*req\s*,\s*res\s*\)\s*=>\s*\{.*?\}\s*\)\s*;'

function Replace-RoutePost {
  param(
    [Parameter(Mandatory)] [string] $File,
    [Parameter(Mandatory)] [string] $NewPostBlock
  )
  if (-not (Test-Path $File)) { Write-Warning "Arquivo não encontrado: $File"; return }
  $text = Get-Content $File -Raw -Encoding UTF8
  if (-not ([regex]::IsMatch($text, $PostPattern))) {
    Write-Warning "Não encontrei router.post('/') em $File — nada alterado."
    return
  }
  Backup $File
  $patched = [regex]::Replace($text, $PostPattern, $NewPostBlock, 1) # somente o 1º
  Set-Content $File -Value $patched -Encoding UTF8
}

function Fix-Clients-ByRegex {
  Write-Verbose "Patch (regex) clients.routes.js"
  $block = @"
router.post('/', async (req, res) => {
  const { tenantId: tId, name, email, phone, document, address } = req.body;
  const id = tId || req.get('x-tenant-id') || req.query.tenantId;
  if (!id)    return res.status(400).json({ error:'bad_request', message:'tenantId required' });
  if (!name)  return res.status(400).json({ error:'bad_request', message:'name required' });
  if (!email) return res.status(400).json({ error:'bad_request', message:'email required' });
  try {
    const client = await prisma.client.create({
      data: {
        tenant:   { connect: { id: String(id) } },
        name:     String(name),
        email:    String(email).toLowerCase(),
        phone:    phone ?? null,
        document: document ?? null,
        address:  address ?? null
      }
    });
    res.status(201).json({ data: client });
  } catch (e) {
    const code = e.code === 'P2002' ? 409 : 500;
    res.status(code).json({ error: code===409?'conflict':'internal_error', message:e.message });
  }
});
"@
  Replace-RoutePost -File $ClientsRoute -NewPostBlock $block
  Write-Host "✔ clients.routes.js (POST) atualizado por regex" -ForegroundColor Green
}

function Fix-Vehicles-ByRegex {
  Write-Verbose "Patch (regex) vehicles.routes.js"
  $block = @"
router.post('/', async (req, res) => {
  const id = req.body.tenantId||req.get('x-tenant-id')||req.query.tenantId;
  if (!id)              return res.status(400).json({ error:'bad_request', message:'tenantId required' });
  if (!req.body.plate)  return res.status(400).json({ error:'bad_request', message:'plate required' });
  try {
    const vehicle = await prisma.vehicle.create({
      data: {
        tenant:   { connect: { id: String(id) } },
        plate:    String(req.body.plate).toUpperCase(),
        brand:    req.body.brand ?? 'Chevrolet',
        model:    req.body.model ?? 'Onix',
        year:     parseInt(req.body.year ?? 2022, 10),
        dailyRate:String(req.body.dailyRate ?? '120.00'),
        status:   req.body.status ?? 'available',
        color:    req.body.color ?? 'Prata',
        fuelType: req.body.fuelType ?? 'Flex',
        category: req.body.category ?? 'Hatch'
      }
    });
    res.status(201).json({ data: vehicle });
  } catch (e) {
    const code = e.code==='P2002'?409:400;
    res.status(code).json({ error:'bad_request', message:e.message });
  }
});
"@
  Replace-RoutePost -File $VehiclesRoute -NewPostBlock $block
  Write-Host "✔ vehicles.routes.js (POST) atualizado por regex" -ForegroundColor Green
}

function Fix-Rentals-ByRegex {
  Write-Verbose "Patch (regex) rentals.routes.js"
  $block = @"
router.post('/', async (req, res) => {
  const id = req.body.tenantId||req.get('x-tenant-id')||req.query.tenantId;
  const { vehicleId, clientId, startDate, endDate, dailyRate, status } = req.body;
  if (!id)         return res.status(400).json({ error:'bad_request', message:'tenantId required' });
  if (!vehicleId)  return res.status(400).json({ error:'bad_request', message:'vehicleId required' });
  if (!clientId)   return res.status(400).json({ error:'bad_request', message:'clientId required' });
  if (!startDate)  return res.status(400).json({ error:'bad_request', message:'startDate required' });
  if (!endDate)    return res.status(400).json({ error:'bad_request', message:'endDate required' });
  try {
    const rental = await prisma.rental.create({
      data: {
        tenant:   { connect: { id: String(id) } },
        vehicle:  { connect: { id: String(vehicleId) } },
        client:   { connect: { id: String(clientId) } },
        startDate:new Date(startDate),
        endDate:  new Date(endDate),
        dailyRate:String(dailyRate ?? '120.00'),
        status:   status ?? 'confirmed'
      }
    });
    res.status(201).json({ data: rental });
  } catch (e) {
    res.status(400).json({ error:'bad_request', message:e.message });
  }
});
"@
  Replace-RoutePost -File $RentalsRoute -NewPostBlock $block
  Write-Host "✔ rentals.routes.js (POST) atualizado por regex" -ForegroundColor Green
}

function Fix-Maintenance-ByRegex {
  Write-Verbose "Patch (regex) maintenances.routes.js"
  $block = @"
router.post('/', async (req, res) => {
  const id = req.body.tenantId||req.get('x-tenant-id')||req.query.tenantId;
  const { vehicleId, description, startDate, endDate, status } = req.body;
  if (!id)          return res.status(400).json({ error:'bad_request', message:'tenantId required' });
  if (!vehicleId)   return res.status(400).json({ error:'bad_request', message:'vehicleId required' });
  if (!description) return res.status(400).json({ error:'bad_request', message:'description required' });
  if (!startDate)   return res.status(400).json({ error:'bad_request', message:'startDate required' });
  try {
    const maint = await prisma.maintenance.create({
      data: {
        tenant:      { connect: { id: String(id) } },
        vehicle:     { connect: { id: String(vehicleId) } },
        description: String(description),
        startDate:   new Date(startDate),
        endDate:     endDate ? new Date(endDate) : null,
        status:      status ?? 'scheduled'
      }
    });
    res.status(201).json({ data: maint });
  } catch (e) {
    res.status(400).json({ error:'bad_request', message:e.message });
  }
});
"@
  Replace-RoutePost -File $MaintRoute -NewPostBlock $block
  Write-Host "✔ maintenances.routes.js (POST) atualizado por regex" -ForegroundColor Green
}

# ---------------- /internal/health/extended ----------------
function Ensure-HealthExtended-ByRegex {
  if (-not (Test-Path $IndexFile)) { Write-Warning "index.js não encontrado: $IndexFile"; return }
  $js = Get-Content $IndexFile -Raw -Encoding UTF8

  if ($js -match '/internal/health/extended') {
    Write-Verbose "/internal/health/extended já existe — nada a fazer"
    return
  }

  $block = @"
const startTs = Date.now();
app.get('/internal/health/extended', async (req, res) => {
  try {
    // Prisma inline para não exigir alteração de imports externos
    const { PrismaClient } = require('@prisma/client');
    const prisma = global.__prisma || new PrismaClient();
    if (!global.__prisma) global.__prisma = prisma;
    await prisma.\$queryRaw\`SELECT 1\`;
    res.json({
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime_ms: Date.now() - startTs,
      checks: { system: 'ok', database: 'ok' }
    });
  } catch (e) {
    res.status(500).json({
      status: 'error',
      message: e?.message || String(e),
      checks: { system: 'ok', database: 'error' }
    });
  }
});
"@

  Backup $IndexFile
  if ($js -match 'app\.listen\s*\(') {
    # Insere antes do primeiro app.listen(
    $patched = $js -replace '(?s)(?=app\.listen\s*\()', ($block + "`r`n")
  } else {
    # Sem app.listen localizado — apenas anexa no fim
    $patched = $js.TrimEnd() + "`r`n`r`n// inserted by setup-magwebapp-regex-health.ps1`r`n" + $block
  }
  Set-Content $IndexFile -Value $patched -Encoding UTF8
  Write-Host "✔ /internal/health/extended inserido no index.js" -ForegroundColor Green
}

# --------------- MagApi.psm1 (reparos) ---------------
function Fix-MagApi {
  Write-Verbose "Patch MagApi.psm1"
  New-Item -ItemType Directory -Force (Split-Path $ModFile -Parent) | Out-Null
  Backup $ModFile

  $modContent = @'
# MagApi - PowerShell Module para interagir com sua API

# Base e Tenant
if (-not $script:MAG_BASE)   { $script:MAG_BASE   = $env:MAG_BASE   ?? "http://localhost:3000" }
if (-not $script:MAG_TENANT) { $script:MAG_TENANT = $env:MAG_TENANT ?? "dev" }
if (-not $Tenant)            { $Tenant            = $script:MAG_TENANT }

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
  try { 
    Invoke-RestMethod @p 
  } catch { 
    throw "API Error $uri : $($_.Exception.Message)" 
  }
}

function Ensure-Client {
  param($email,[string]$name)
  $qs    = @("tenantId=$Tenant","email=$([uri]::EscapeDataString($email))")
  $found = As-Array ((GetJson "/api/v1/clients?$( $qs -join '&' )").data)
  if ($found.Count) { 
    $found[0] 
  } else { 
    (GetJson "/api/v1/clients" -Method POST -Body @{ tenantId=$Tenant; email=$email; name=$name }).data 
  }
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
  if ($OnlyStatuses.Count) {
    $all = $all | Where-Object { $OnlyStatuses -contains $_.status }
  }
  if (-not $all.Count) {
    Write-Host "Nenhuma locação para $vehicleId" -ForegroundColor Yellow
  } else {
    $all | Format-Table id, status, startDate, endDate -AutoSize
  }
}

function Mag-Boot {
  Write-Host "🔧 Criando dados de teste..." -ForegroundColor Cyan
  # Cliente
  $c = (GetJson "/api/v1/clients?tenantId=$Tenant&limit=1").data | Select-Object -First 1
  if (-not $c) { 
    $c = (GetJson "/api/v1/clients" -Method POST -Body @{ tenantId=$Tenant; name="Cliente Teste"; email="cliente.teste@example.com" }).data 
  }
  # Veículo (independente de client)
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
      tenantId  = $Tenant
      vehicleId = $v.id
      clientId  = $c.id
      startDate = $s.ToString("o")
      endDate   = $e.ToString("o")
      dailyRate = "120.00"
      status    = "confirmed"
    }).data
  }
  Write-Host "🎉 Dados de teste criados! VehicleId: $($v.id)" -ForegroundColor Green
}

function Initialize-Maintenance {
  param($vehicleId,[string]$description,[int]$days=1)
  $qs    = @("tenantId=$Tenant","vehicleId=$vehicleId","status=scheduled","limit=1")
  $found = As-Array ((GetJson "/api/v1/maintenances?$( $qs -join '&' )").data)
  if ($found.Count) {
    Write-Host "Manutenção já existe: $description" -ForegroundColor Gray
    return $found[0]
  }
  Write-Host "Criando manutenção: $description" -ForegroundColor Yellow
  $s = Get-Date; $e = $s.AddDays($days)
  (GetJson "/api/v1/maintenances" -Method POST -Body @{
    tenantId    = $Tenant
    vehicleId   = $vehicleId
    description = $description
    startDate   = $s.ToString("o")
    endDate     = $e.ToString("o")
    status      = "scheduled"
  }).data
}

Export-ModuleMember -Function *
'@

  Set-Content $ModFile -Value $modContent -Encoding UTF8
  Remove-Module MagApi -ErrorAction SilentlyContinue
  Import-Module $ModFile -Force -DisableNameChecking -Verbose
  Write-Host "✔ MagApi.psm1 atualizado e recarregado" -ForegroundColor Green
}

# ---------------- Execução ----------------
try {
  Test-Database
  Stop-PrismaStudio
  Run-Migrations
  Ensure-TenantDev

  Fix-Clients-ByRegex
  Fix-Vehicles-ByRegex
  Fix-Rentals-ByRegex
  Fix-Maintenance-ByRegex

  Ensure-HealthExtended-ByRegex
  Fix-MagApi

  Write-Host "`n✅ Setup (regex + health/extended) concluído! Próximos passos:" -ForegroundColor White
  Write-Host "1) cd apps/api && npm run dev   (suba a API visível)" -ForegroundColor Cyan
  Write-Host "2) `$env:MAG_TENANT='dev'       (ou Set-Variable -Name MAG_TENANT -Value 'dev')" -ForegroundColor Cyan
  Write-Host "3) Import-Module `"$HOME\Documents\PowerShell\Modules\MagApi\MagApi.psm1`" -Force" -ForegroundColor Cyan
  Write-Host "4) Mag-Boot                      (gera cliente/veículo/locação)" -ForegroundColor Cyan
  Write-Host "5) Teste os healths: irm http://localhost:3000/internal/health  e  /internal/health/extended" -ForegroundColor Cyan
  Write-Host "6) Initialize-Maintenance -vehicleId <vehicleId> -description 'Teste' -days 2" -ForegroundColor Cyan
} catch {
  Write-Error "❌ Falha no setup: $_"; exit 1
}
