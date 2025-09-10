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
        Write-Warn "Extended health não disponível: $_"
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

EXAMPLES:
  .\tools-mag-api.ps1 -Cmd api:start -Port 3000
  .\tools-mag-api.ps1 -Cmd health
"@
}

# Main command dispatcher
switch ($Cmd) {
    "api:stop"     { Stop-ApiPort $Port }
    "api:start"    { Stop-ApiPort $Port; Start-Api $Port }
    "api:restart"  { Stop-ApiPort $Port; Start-Sleep 2; Start-Api $Port }
    "health"       { Test-Health }
    default        { Show-Help }
}
