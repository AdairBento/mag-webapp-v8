# ============================================
# Teste de Regressão API - Locadora
# ============================================

# --- Vars básicas ---
$base = "http://localhost:3000"
$start = "2025-12-15T12:00:00.000Z"
$end   = "2025-12-17T12:00:00.000Z"
# --- UTF-8 console ---
try {
  chcp 65001 > $null
} catch {}
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== 1) Health ==="
irm "$base/internal/health" | ConvertTo-Json -Depth 3

# --- Seed ---
Write-Host "`n=== 2) Seed ==="
$seed = irm -Method POST "$base/internal/seed"
$tenantId  = $seed.tenant.id
$clientId  = $seed.client.id
$vehicleId = $seed.vehicle.id
Write-Host "Tenant=$tenantId"
Write-Host "Client=$clientId"
Write-Host "Vehicle=$vehicleId"

# --- Criar rental ---
Write-Host "`n=== 3) Criar Rental (pending) ==="
$bodyCreate = @{
  tenantId  = $tenantId
  clientId  = $clientId
  vehicleId = $vehicleId
  startDate = $start
  endDate   = $end
  amount    = "240.00"
  status    = "pending"
} | ConvertTo-Json

$rental = irm "$base/api/v1/rentals" -Method POST -ContentType "application/json" -Body $bodyCreate
$rentalId = $rental.data.id
Write-Host "RentalId=$rentalId"

# --- Confirmar rental ---
Write-Host "`n=== 4) Confirmar Rental ==="
$bodyConfirm = @{ status = "confirmed" } | ConvertTo-Json
$confirmed = irm "$base/api/v1/rentals/$rentalId" -Method PATCH -ContentType "application/json" -Body $bodyConfirm
$confirmed | ConvertTo-Json -Depth 4

# --- Tentar conflito ---
Write-Host "`n=== 5) Testar Conflito ==="
$bodyConflito = @{
  tenantId  = $tenantId
  clientId  = $clientId
  vehicleId = $vehicleId
  startDate = "2025-12-16T12:00:00.000Z" # sobrepõe
  endDate   = "2025-12-18T12:00:00.000Z"
  amount    = "240.00"
  status    = "pending"
} | ConvertTo-Json

try {
  irm "$base/api/v1/rentals" -Method POST -ContentType "application/json" -Body $bodyConflito
  Write-Warning "⚠️ ERRO: Permitiu conflito!"
} catch {
  Write-Host "✅ Conflito bloqueado corretamente (409)."
}

# --- Availability ---
Write-Host "`n=== 6) Availability ==="
$from = "2025-12-01"
$to   = "2025-12-31"
$availability = irm "$base/api/v1/availability?tenantId=$tenantId&startDate=$from&endDate=$to"
$availability | ConvertTo-Json -Depth 4

# --- Deletar rental ---
Write-Host "`n=== 7) Deletar Rental ==="
$deleted = irm "$base/api/v1/rentals/$rentalId" -Method DELETE
$deleted | ConvertTo-Json -Depth 4

Write-Host "`n=== 8) Confirmar exclusão ==="
try {
  irm "$base/api/v1/rentals/$rentalId"
  Write-Warning "⚠️ ERRO: Rental ainda existe!"
} catch {
  Write-Host "✅ Rental realmente removido (404)."
}

Write-Host "`n=== Fluxo de regressão concluído com sucesso ==="
