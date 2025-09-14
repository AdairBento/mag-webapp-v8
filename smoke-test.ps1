# Script de teste completo para validar toda a API MAG
param(
    [string]$Base = "http://localhost:3000",
    [string]$Tenant = "dev"
)

Write-Host "=== TESTE COMPLETO DA API MAG ===" -ForegroundColor Green
Write-Host "Base URL: $Base" -ForegroundColor Cyan
Write-Host "Tenant: $Tenant" -ForegroundColor Cyan
Write-Host ""

# 1. Teste de Health Check
Write-Host "1. Testando Health Check..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "$Base/internal/health" -Method GET -TimeoutSec 10
    if ($health.ok) {
        Write-Host "✓ Health Check OK" -ForegroundColor Green
    } else {
        Write-Host "❌ Health Check falhou" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Erro no Health Check: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 2. Teste Extended Health Check
Write-Host "2. Testando Extended Health Check..." -ForegroundColor Yellow
try {
    $healthExt = Invoke-RestMethod -Uri "$Base/internal/health/extended" -Method GET -TimeoutSec 10
    if ($healthExt.status -eq "ok") {
        Write-Host "✓ Extended Health Check OK - Uptime: $($healthExt.uptime_ms)ms" -ForegroundColor Green
    } else {
        Write-Host "❌ Extended Health Check falhou" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Erro no Extended Health Check: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. Teste GET Vehicles (deve funcionar mesmo sem dados)
Write-Host "3. Testando GET Vehicles..." -ForegroundColor Yellow
try {
    $vehicles = Invoke-RestMethod -Uri "$Base/api/v1/vehicles" -Headers @{"x-tenant-id" = $Tenant} -Method GET -TimeoutSec 10
    Write-Host "✓ GET Vehicles OK - $($vehicles.data.Count) veículos encontrados" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro no GET Vehicles: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. Teste POST Vehicle
Write-Host "4. Testando POST Vehicle..." -ForegroundColor Yellow
$plateRandom = "TST$([int](Get-Random -Minimum 1000 -Maximum 9999))"
$vehiclePayload = @{
    tenantId = $Tenant
    plate = $plateRandom
    brand = "Toyota"
    model = "Test Corolla"
    year = 2024
    status = "available"
} | ConvertTo-Json

try {
    $newVehicle = Invoke-RestMethod -Uri "$Base/api/v1/vehicles" -Method POST -Body $vehiclePayload -ContentType "application/json" -TimeoutSec 10
    Write-Host "✓ POST Vehicle OK - ID: $($newVehicle.data.id)" -ForegroundColor Green
    $vehicleId = $newVehicle.data.id
} catch {
    Write-Host "❌ Erro no POST Vehicle: $($_.Exception.Message)" -ForegroundColor Red
    $vehicleId = $null
}

# 5. Teste GET Clients
Write-Host "5. Testando GET Clients..." -ForegroundColor Yellow
try {
    $clients = Invoke-RestMethod -Uri "$Base/api/v1/clients" -Headers @{"x-tenant-id" = $Tenant} -Method GET -TimeoutSec 10
    Write-Host "✓ GET Clients OK - $($clients.data.Count) clientes encontrados" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro no GET Clients: $($_.Exception.Message)" -ForegroundColor Red
}

# 6. Teste POST Client
Write-Host "6. Testando POST Client..." -ForegroundColor Yellow
$clientPayload = @{
    tenantId = $Tenant
    name = "Cliente Teste $(Get-Random)"
    email = "teste@example.com"
    phone = "+55 11 99999-9999"
    document = "123.456.789-00"
} | ConvertTo-Json

try {
    $newClient = Invoke-RestMethod -Uri "$Base/api/v1/clients" -Method POST -Body $clientPayload -ContentType "application/json" -TimeoutSec 10
    Write-Host "✓ POST Client OK - ID: $($newClient.data.id)" -ForegroundColor Green
    $clientId = $newClient.data.id
} catch {
    Write-Host "❌ Erro no POST Client: $($_.Exception.Message)" -ForegroundColor Red
    $clientId = $null
}

# 7. Teste GET Tenants
Write-Host "7. Testando GET Tenants..." -ForegroundColor Yellow
try {
    $tenants = Invoke-RestMethod -Uri "$Base/api/v1/tenants" -Method GET -TimeoutSec 10
    Write-Host "✓ GET Tenants OK - $($tenants.data.Count) tenants encontrados" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro no GET Tenants: $($_.Exception.Message)" -ForegroundColor Red
}

# 8. Teste GET Rentals
Write-Host "8. Testando GET Rentals..." -ForegroundColor Yellow
try {
    $rentals = Invoke-RestMethod -Uri "$Base/api/v1/rentals" -Headers @{"x-tenant-id" = $Tenant} -Method GET -TimeoutSec 10
    Write-Host "✓ GET Rentals OK - $($rentals.data.Count) aluguéis encontrados" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro no GET Rentals: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# 9. Teste POST Rental (se temos client e vehicle)
if ($clientId -and $vehicleId) {
    Write-Host "9. Testando POST Rental..." -ForegroundColor Yellow
    $startDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    $endDate = (Get-Date).AddDays(3).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    
    $rentalPayload = @{
        tenantId = $Tenant
        clientId = $clientId
        vehicleId = $vehicleId
        startDate = $startDate
        endDate = $endDate
        amount = "250.00"
        status = "pending"
    } | ConvertTo-Json

    try {
        $newRental = Invoke-RestMethod -Uri "$Base/api/v1/rentals" -Method POST -Body $rentalPayload -ContentType "application/json" -TimeoutSec 10
        Write-Host "✓ POST Rental OK - ID: $($newRental.data.id)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Erro no POST Rental: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "  Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
} else {
    Write-Host "9. Pulando teste POST Rental (faltam client ou vehicle)" -ForegroundColor Yellow
}

# 10. Resumo Final
Write-Host ""
Write-Host "=== RESUMO DO TESTE ===" -ForegroundColor Green
Write-Host "Base URL testada: $Base" -ForegroundColor Cyan
Write-Host "Tenant usado: $Tenant" -ForegroundColor Cyan
if ($vehicleId) { Write-Host "Vehicle criado: $vehicleId" -ForegroundColor Cyan }
if ($clientId) { Write-Host "Client criado: $clientId" -ForegroundColor Cyan }
Write-Host ""
Write-Host "Teste concluído!" -ForegroundColor Green