using namespace System.Globalization

# ====================================================================
# SMOKE TEST COMPLETO - VERSÃO CORRIGIDA E ROBUSTA
# ====================================================================

param(
    [string]$Base   = 'http://localhost:3000',
    [string]$Tenant = '022d0c59-4363-4993-a485-9adf29719824',
    [string]$Email  = 'joao.silva+smoke@example.com',
    [string]$Plate  = 'SMK1D2',
    [string]$From   = '2025-09-24',
    [string]$To     = '2025-09-27'
)

function Write-Step([string]$m)   { Write-Host $m -ForegroundColor Cyan }
function Write-Ok([string]$m)     { Write-Host $m -ForegroundColor Green }
function Write-Warn([string]$m)   { Write-Host $m -ForegroundColor Yellow }
function Write-Error2([string]$m) { Write-Host $m -ForegroundColor Red }

function UrlJoin([string]$a,[string]$b) { ($a.TrimEnd('/')) + '/' + ($b.TrimStart('/')) }

function Get-Json([string]$url) {
    try {
        Write-Host "  🌐 GET $url" -ForegroundColor Gray
        $result = Invoke-RestMethod -Method GET -Uri $url -TimeoutSec 10 -ErrorAction Stop
        Write-Host "  ✅ OK" -ForegroundColor Green
        return $result
    } catch {
        Write-Host "  ❌ ERRO: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Parse-DateSafe([string]$dateString) {
    if ([string]::IsNullOrWhiteSpace($dateString)) { return $null }
    $formats = @(
        'yyyy-MM-ddTHH:mm:ss.fffK',
        'yyyy-MM-ddTHH:mm:ssK',
        'yyyy-MM-ddTHH:mm:ssZ',
        'yyyy-MM-dd',
        'MM/dd/yyyy HH:mm:ss',
        'dd/MM/yyyy HH:mm:ss',
        'yyyy-MM-dd HH:mm:ss',
        'MM/dd/yyyy',
        'dd/MM/yyyy'
    )
    try {
        return [datetime]::ParseExact(
            $dateString.Trim(),
            $formats,
            [CultureInfo]::InvariantCulture,
            [DateTimeStyles]::RoundtripKind
        )
    } catch {
        try {
            return [datetime]::Parse(
                $dateString.Trim(),
                [CultureInfo]::InvariantCulture,
                [DateTimeStyles]::AssumeUniversal
            )
        } catch {
            Write-Warn "Não foi possível parsear a data: $dateString"
            return $null
        }
    }
}

function Overlaps([datetime]$aStart,[datetime]$aEnd,[datetime]$bStart,[datetime]$bEnd) {
    if ($aStart -eq $null -or $aEnd -eq $null -or $bStart -eq $null -or $bEnd -eq $null) { return $false }
    ($aStart -le $bEnd) -and ($bStart -le $aEnd)
}

Write-Host "`n🚀 SMOKE TEST - LOCAÇÕES MAG API" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "Base URL: $Base" -ForegroundColor Gray
Write-Host "Tenant: $Tenant" -ForegroundColor Gray
Write-Host "Período: $From → $To" -ForegroundColor Gray
Write-Host "Cliente: $Email" -ForegroundColor Gray
Write-Host "Veículo: $Plate" -ForegroundColor Gray

$fromDt = Get-Date $From
$toDt   = Get-Date $To

# 1) Health
Write-Step "`n1. 🏥 Health check..."
$health = Get-Json (UrlJoin $Base 'internal/health')
if (-not $health) { Write-Error2 "API indisponível - verifique o servidor"; exit 1 }
Write-Ok "API online - $($health.timestamp)"

# 2) Cliente
Write-Step "`n2. 👤 Procurando cliente ($Email)..."
$clientsResponse = Get-Json (UrlJoin $Base "api/v1/clients?tenantId=$Tenant&page=1&limit=200")
if (-not $clientsResponse) { Write-Error2 "Erro ao buscar clientes"; exit 1 }
$client = $clientsResponse.data | Where-Object { $_.email -eq $Email } | Select-Object -First 1
if (-not $client) {
    Write-Warn "Cliente não encontrado"
    $clientsResponse.data | ForEach-Object { Write-Host "  - $($_.email)" -ForegroundColor Gray }
} else {
    Write-Ok "Cliente encontrado: $($client.id) - $($client.name)"
}

# 3) Veículo
Write-Step "`n3. 🚗 Procurando veículo ($Plate)..."
$vehiclesResponse = Get-Json (UrlJoin $Base "api/v1/vehicles?tenantId=$Tenant&page=1&limit=200")
if (-not $vehiclesResponse) { Write-Error2 "Erro ao buscar veículos"; exit 1 }
$vehicle = $vehiclesResponse.data | Where-Object { $_.plate -eq $Plate } | Select-Object -First 1
if (-not $vehicle) {
    Write-Warn "Veículo não encontrado"
    $vehiclesResponse.data | ForEach-Object { Write-Host "  - $($_.plate)" -ForegroundColor Gray }
} else {
    Write-Ok "Veículo encontrado: $($vehicle.id) - $($vehicle.plate)"
}

# 4) Idempotência
Write-Step "`n4. 📅 Verificando locações existentes para idempotência..."
$rentalsResponse = Get-Json (UrlJoin $Base "api/v1/rentals?tenantId=$Tenant&page=1&limit=200")
$existing = @(); $totalRentals = 0

if ($rentalsResponse -and $rentalsResponse.data) {
    $totalRentals = $rentalsResponse.data.Count
    Write-Host "  📊 Total de locações no sistema: $totalRentals" -ForegroundColor Gray

    $relevantRentals = $rentalsResponse.data | Where-Object {
        ($client  -and $_.clientId  -eq $client.id) -and
        ($vehicle -and $_.vehicleId -eq $vehicle.id)
    }

    if ($relevantRentals.Count -gt 0) {
        Write-Host "  🔍 Locações do cliente+veículo: $($relevantRentals.Count)" -ForegroundColor Gray

        $existing = $relevantRentals | ForEach-Object {
            try {
                if ($_.startDate -and $_.endDate) {
                    $s = Parse-DateSafe $_.startDate
                    $e = Parse-DateSafe $_.endDate
                    if ($s -and $e) {
                        $rental = [pscustomobject]@{ id=$_.id; startDate=$s; endDate=$e; status=$_.status }
                        if (Overlaps $fromDt $toDt $s $e) {
                            Write-Host "    ⚠️  Conflito: ID=$($_.id) ($($s.ToString('yyyy-MM-dd')) → $($e.ToString('yyyy-MM-dd'))) Status=$($_.status)" -ForegroundColor Yellow
                            return $rental
                        } else {
                            Write-Host "    ✅ OK: ID=$($_.id) ($($s.ToString('yyyy-MM-dd')) → $($e.ToString('yyyy-MM-dd'))) - Sem conflito" -ForegroundColor Green
                        }
                    } else {
                        Write-Warn "    ❌ Locação $($_.id) com datas inválidas"
                    }
                }
            } catch {
                Write-Warn "    ❌ Erro processando locação $($_.id): $($_.Exception.Message)"
            }
            return $null
        } | Where-Object { $_ -ne $null }
    } else {
        Write-Host "  ✅ Nenhuma locação anterior deste cliente+veículo" -ForegroundColor Green
    }
} else {
    Write-Host "  📊 Nenhuma locação no sistema" -ForegroundColor Gray
}

# 5) Resultado
Write-Step "`n5. 📋 Resultado da verificação de idempotência..."
if ($existing.Count -gt 0) {
    Write-Warn "⚠️  CONFLITOS ENCONTRADOS ($($existing.Count) locações):"
    $existing | ForEach-Object {
        Write-Host "  • ID: $($_.id)" -ForegroundColor Red
        Write-Host "    Período: $($_.startDate.ToString('yyyy-MM-dd')) → $($_.endDate.ToString('yyyy-MM-dd'))" -ForegroundColor Red
        Write-Host "    Status: $($_.status)" -ForegroundColor Red
        Write-Host "    Solicitado: $($fromDt.ToString('yyyy-MM-dd')) → $($toDt.ToString('yyyy-MM-dd'))" -ForegroundColor Yellow
    }
    Write-Host "`n❌ NÃO É SEGURO CRIAR NOVA LOCAÇÃO (não idempotente)" -ForegroundColor Red
} else {
    Write-Ok "✅ NENHUM CONFLITO ENCONTRADO"
    Write-Ok "✅ É SEGURO CRIAR NOVA LOCAÇÃO (idempotente)"
}

# 6) Resumo
Write-Host "`n" -NoNewline
Write-Host "📊 RESUMO FINAL" -ForegroundColor Magenta
Write-Host "==================" -ForegroundColor Magenta

if ($client)  { Write-Host "✅ Cliente: $($client.name) ($($client.email))" -ForegroundColor Green } else { Write-Host "❌ Cliente: Não encontrado" -ForegroundColor Red }
if ($vehicle) { Write-Host "✅ Veículo: $($vehicle.plate)"               -ForegroundColor Green } else { Write-Host "❌ Veículo: Não encontrado" -ForegroundColor Red }

Write-Host "📅 Período: $($fromDt.ToString('yyyy-MM-dd')) → $($toDt.ToString('yyyy-MM-dd'))" -ForegroundColor Gray
Write-Host "📊 Total de locações no sistema: $totalRentals" -ForegroundColor Gray

if ($existing.Count -eq 0) { Write-Host "🎉 RESULTADO: TESTE PASSOU - Pode prosseguir com a criação" -ForegroundColor Green; exit 0 }
else                       { Write-Host "🚫 RESULTADO: TESTE FALHOU - Conflitos detectados"      -ForegroundColor Red;   exit 1 }

Write-Host "`n" -NoNewline
