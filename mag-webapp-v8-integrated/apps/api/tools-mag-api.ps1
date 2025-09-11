# MAG API - Ferramentas de desenvolvimento e operação
# Versão atualizada com suporte aos novos middlewares + correções de path/amount/log

param(
    [string]$Cmd,
    [int]$Port = 3000,
    [string]$RentalId,
    [string]$ConflictId,
    [string]$Env = "development"
)

$base = "http://localhost:$Port"

function Write-Info($message) {
    Write-Host "[INFO] $message" -ForegroundColor Green
}
function Write-Warn($message) {
    Write-Host "[WARN] $message" -ForegroundColor Yellow
}
function Write-Err($message) {
    Write-Host "[ERROR] $message" -ForegroundColor Red
}

function Resolve-ApiPath {
    $candidates = @(
        "apps/api",
        "mag-webapp-v8-integrated/apps/api"
    )
    foreach ($p in $candidates) {
        if (Test-Path (Join-Path $p "package.json")) { return (Resolve-Path $p).Path }
        if (Test-Path (Join-Path $p "src/index.js")) { return (Resolve-Path $p).Path }
    }
    return $null
}

function Stop-ApiPort($port) {
    try {
        $connections = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
        if ($connections) {
            foreach ($conn in $connections) {
                $process = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
                if ($process) {
                    Write-Info "Killing PID $($process.Id) on port $port ..."
                    Stop-Process -Id $process.Id -Force
                }
            }
            Start-Sleep 1
        }
        Write-Info "Port $port is now free."
    } catch {
        Write-Warn "Could not check/free port $port. Error: $_"
    }
}

function Start-Api($port) {
    $apiPath = Resolve-ApiPath
    if (-not $apiPath) {
        Write-Err "Não encontrei a pasta da API. Esperado 'apps/api' ou 'mag-webapp-v8-integrated/apps/api'."
        return
    }

    Write-Info "Port $port already free."
    Write-Info "Starting API at http://localhost:$port ..."
    
    $orig = Get-Location
    try {
        Set-Location $apiPath
        $env:PORT = $port
        $env:NODE_ENV = $Env

        if (-not (Test-Path "package.json")) {
            Write-Warn "package.json não encontrado — vou tentar 'npx nodemon src/index.js'."
            npx nodemon "src/index.js"
            return
        }

        $pkg = Get-Content package.json | ConvertFrom-Json
        if ($pkg.scripts -and $pkg.scripts.dev) {
            npm run dev
        } else {
            npx nodemon "src/index.js"
        }
    } finally {
        Set-Location $orig
    }
}

function Test-Health() {
    Write-Info "Testing health endpoints..."
    try {
        $health = irm "$base/internal/health"
        Write-Info "Basic health: $($health.status)"
    } catch {
        Write-Err "Basic /internal/health failed: $_"
        return
    }

    try {
        $extendedHealth = irm "$base/internal/health/extended"
        Write-Info "Extended health: $($extendedHealth.status)"
        if ($extendedHealth.checks) {
            foreach ($checkName in $extendedHealth.checks.PSObject.Properties.Name) {
                $check = $extendedHealth.checks.$checkName
                $status = $check.status
                $color = switch ($status) {
                    "ok" { "Green" }
                    "warning" { "Yellow" }
                    "error" { "Red" }
                    default { "White" }
                }
                Write-Host "  - $checkName`: $status" -ForegroundColor $color
            }
        }
    } catch {
        Write-Warn "Extended health não disponível (ok se você não ligou esse endpoint): $_"
    }
}

function Get-Metrics() {
    Write-Info "Fetching API metrics..."
    try {
        $metrics = irm "$base/internal/metrics"
        Write-Info "Metrics collected at: $($metrics.timestamp)"
        Write-Info "Uptime: $([math]::Round($metrics.uptime, 2)) seconds"
        
        $summary = $metrics.metrics.summary
        if ($summary) {
            Write-Host "Summary:" -ForegroundColor Cyan
            Write-Host "  Total Requests: $($summary.totalRequests)"
            Write-Host "  Total Errors: $($summary.totalErrors)"
            Write-Host "  Error Rate: $($summary.errorRate)"
            Write-Host "  Avg Duration: $($summary.avgDuration)"
        }

        if ($metrics.metrics.routes) {
            Write-Host "`nTop Routes:" -ForegroundColor Cyan
            $metrics.metrics.routes.PSObject.Properties | 
                Sort-Object {$_.Value.count} -Descending | 
                Select-Object -First 5 | 
                ForEach-Object {
                    $route = $_.Name
                    $stats = $_.Value
                    Write-Host "  $route`: $($stats.count) requests, $($stats.avgDuration)ms avg, $($stats.errorRate) errors"
                }
        }
    } catch {
        Write-Warn "Metrics não disponível (ok se você não ligou esse endpoint): $_"
    }
}

function Remove-ConflictRental($conflictId) {
    if (-not $conflictId) { Write-Err "ConflictId is required"; return }
    Write-Info "Removing conflict rental: $conflictId"
    try {
        $result = irm "$base/api/v1/rentals/$conflictId" -Method DELETE
        Write-Info "Rental removed: $($result.message)"
    } catch {
        Write-Err "Failed to remove rental: $_"
    }
}

function Test-ApiFlow() {
    Write-Info "Testing complete API flow..."
    try {
        # 1. Seed
        Write-Info "1. Creating seed data..."
        $seed = irm -Method POST "$base/internal/seed"
        $tenantId = $seed.tenant.id
        $clientId = $seed.client.id
        $vehicleId = $seed.vehicle.id
        Write-Info "  Tenant: $tenantId"
        Write-Info "  Client: $clientId"
        Write-Info "  Vehicle: $vehicleId"
        
        # 2. Create rental (amount como string com 2 casas p/ compatibilidade)
        Write-Info "2. Creating rental..."
        $createBody = @{
            tenantId = $tenantId
            clientId = $clientId
            vehicleId = $vehicleId
            startDate = "2025-12-15T12:00:00.000Z"
            endDate   = "2025-12-17T12:00:00.000Z"
            amount    = "240.50" # string 2 casas; funciona mesmo sem normalizador
            status    = "pending"
        } | ConvertTo-Json
        $rental = irm "$base/api/v1/rentals" -Method POST -ContentType "application/json" -Body $createBody
        $rentalId = $rental.data.id
        Write-Info "  Created rental: $rentalId"
        if ($rental.data.amount) { Write-Info "  Amount: $($rental.data.amount)" }
        
        # 3. Update status
        Write-Info "3. Confirming rental..."
        $updateBody = @{ status = "confirmed" } | ConvertTo-Json
        $updated = irm "$base/api/v1/rentals/$rentalId" -Method PATCH -ContentType "application/json" -Body $updateBody
        Write-Info "  Status updated to: $($updated.data.status)"
        
        # 4. Availability
        Write-Info "4. Testing availability..."
        $availability = irm "$base/api/v1/availability?tenantId=$tenantId&startDate=2025-12-01&endDate=2025-12-31"
        if ($availability.meta) {
            Write-Info "  Blocked vehicles: $($availability.meta.blockedVehicleCount)"
        } else {
            Write-Warn "  Availability retornou sem 'meta' (confira controller)."
        }
        
        # 5. Conflict
        Write-Info "5. Testing conflict detection..."
        try {
            $conflictBody = @{
                tenantId = $tenantId
                clientId = $clientId
                vehicleId = $vehicleId
                startDate = "2025-12-16T10:00:00.000Z"  # Overlap
                endDate   = "2025-12-18T10:00:00.000Z"
                amount    = "150.00"
                status    = "pending"
            } | ConvertTo-Json
            irm "$base/api/v1/rentals" -Method POST -ContentType "application/json" -Body $conflictBody
            Write-Warn "  ⚠ Não veio 409 — verifique a validação de conflito."
        } catch {
            if ($_.Exception.Message -like "*409*") {
                Write-Info "  ✓ Conflict properly detected"
            } else {
                Write-Err "  Unexpected error: $_"
            }
        }
        
        # 6. Complete and delete
        Write-Info "6. Completing and cleaning up..."
        $completeBody = @{ status = "completed" } | ConvertTo-Json
        irm "$base/api/v1/rentals/$rentalId" -Method PATCH -ContentType "application/json" -Body $completeBody | Out-Null
        irm "$base/api/v1/rentals/$rentalId" -Method DELETE | Out-Null
        Write-Info "  ✓ Rental completed and deleted"
        
        Write-Info "✅ API flow test completed successfully!"
    } catch {
        Write-Err "API flow test failed: $_"
    }
}

function Show-Help() {
    Write-Host @"
MAG API Tools - Usage:

BASIC OPERATIONS:
  .\tools-mag-api.ps1 -Cmd api:stop    -Port 3000
  .\tools-mag-api.ps1 -Cmd api:start   -Port 3000
  .\tools-mag-api.ps1 -Cmd api:restart -Port 3000

HEALTH & MONITORING:
  .\tools-mag-api.ps1 -Cmd health
  .\tools-mag-api.ps1 -Cmd metrics

TESTING:
  .\tools-mag-api.ps1 -Cmd test:flow
  .\tools-mag-api.ps1 -Cmd test:health

CLEANUP:
  .\tools-mag-api.ps1 -Cmd clean:conflicts
  .\tools-mag-api.ps1 -Cmd remove:rental   -RentalId "uuid"
  .\tools-mag-api.ps1 -Cmd remove:conflict -ConflictId "uuid"

EXAMPLES:
  # Start API in production mode
  .\tools-mag-api.ps1 -Cmd api:start -Port 3000 -Env production
  
  # Remove specific conflict
  .\tools-mag-api.ps1 -Cmd remove:conflict -ConflictId "65722bb6-bf06-42e6-9d18-9e13739d15ea"
  
  # Full health check
  .\tools-mag-api.ps1 -Cmd health
"@
}

# Main command dispatcher
switch ($Cmd) {
    "api:stop"     { Stop-ApiPort $Port }
    "api:start"    { Stop-ApiPort $Port; Start-Api $Port }
    "api:restart"  { Stop-ApiPort $Port; Start-Sleep 2; Start-Api $Port }
    "health"       { Test-Health }
    "metrics"      { Get-Metrics }
    "test:flow"    { Test-ApiFlow }
    "test:health"  { Test-Health }
    "remove:rental"   { if ($RentalId) { Remove-ConflictRental $RentalId } else { Write-Err "RentalId parameter is required" } }
    "remove:conflict" { if ($ConflictId) { Remove-ConflictRental $ConflictId } else { Write-Err "ConflictId parameter is required" } }
    "clean:conflicts" {
        Write-Info "Listing all pending rentals for manual cleanup..."
        try {
            $seed = irm -Method POST "$base/internal/seed"
            $tenantId = $seed.tenant.id
            $rentals = irm "$base/api/v1/rentals?tenantId=$tenantId&status=pending"
            if ($rentals.data.Count -gt 0) {
                Write-Host "Pending rentals found:" -ForegroundColor Yellow
                foreach ($rental in $rentals.data) {
                    Write-Host "  ID: $($rental.id) | $($rental.startDate) to $($rental.endDate)"
                }
                Write-Host "`nTo remove a specific rental, use:"
                Write-Host "  .\tools-mag-api.ps1 -Cmd remove:rental -RentalId 'ID'"
            } else {
                Write-Info "No pending rentals found"
            }
        } catch {
            Write-Err "Failed to list rentals: $_"
        }
    }
    default { if ($Cmd) { Write-Err "Unknown command: $Cmd" }; Show-Help }
}
