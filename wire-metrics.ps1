#Requires -Version 7.0
[CmdletBinding()]
param(
  [int]$ApiPort   = 3000,
  [int]$Pm2Port   = 9209,
  [int]$Instances = 2
)

$ErrorActionPreference = "Stop"
function Info($m){ Write-Host $m -ForegroundColor Cyan }
function Ok($m){ Write-Host $m -ForegroundColor Green }
function Warn($m){ Write-Warning $m }
function Backup($path){
  if(Test-Path $path){
    $bak = "$path.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $path $bak -Force
    Write-Host "Backup → $bak" -ForegroundColor DarkGray
  }
}

$Root = Get-Location
$PromFile = Join-Path $Root "prometheus.yml"
$Compose = Join-Path $Root "docker-compose.yml"

# 0) Garantir pm2 e módulo de métricas
Info "Checando PM2 e módulo pm2-metrics…"
if(-not (Get-Command npm -ErrorAction SilentlyContinue)){ throw "npm não encontrado no PATH." }
if(-not (Get-Command node -ErrorAction SilentlyContinue)){ throw "node não encontrado no PATH." }

# PM2 via npx sempre disponível
$npx = "npx"

# Instala/ajusta pm2-metrics
& $npx pm2 install pm2-metrics | Out-Null
& $npx pm2 set pm2-metrics:host "0.0.0.0" | Out-Null
& $npx pm2 set pm2-metrics:port "$Pm2Port" | Out-Null

# 1) Atualizar/gerar prometheus.yml (scrape pm2 + api)
Info "Atualizando prometheus.yml…"
$yaml = @"
global:
  scrape_interval: 5s
scrape_configs:
  - job_name: 'pm2'
    static_configs:
      - targets: ['host.docker.internal:$Pm2Port']
  - job_name: 'api'
    metrics_path: /internal/metrics
    static_configs:
      - targets: ['host.docker.internal:$ApiPort']
"@
Backup $PromFile
$yaml | Set-Content -Encoding UTF8 $PromFile
Ok "prometheus.yml atualizado."

# 2) docker-compose mínimo para Prometheus + Grafana (se não existir)
if(-not (Test-Path $Compose)){
  Info "Criando docker-compose.yml (Prometheus + Grafana)…"
  $composeYml = @"
version: '3.8'
services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-storage:/var/lib/grafana

volumes:
  grafana-storage:
"@
  $composeYml | Set-Content -Encoding UTF8 $Compose
  Ok "docker-compose.yml criado."
} else {
  Info "docker-compose.yml já existe — não alterei."
}

# 3) Criar/ajustar scripts no package.json
$Pkg = Join-Path $Root "package.json"
if(-not (Test-Path $Pkg)){ throw "package.json não encontrado na raiz." }

Info "Ajustando scripts no package.json…"
Backup $Pkg
$pkgJson = Get-Content $Pkg -Raw | ConvertFrom-Json

if(-not $pkgJson.scripts){ $pkgJson | Add-Member -NotePropertyName scripts -NotePropertyValue (@{}) }
$pkgJson.scripts.build      = "tsc -p tsconfig.json"
$pkgJson.scripts.start      = "node ./dist/apps/api/src/server.js"
$pkgJson.scripts."start:pm2"= "pm2 start ecosystem.config.js"

$pkgJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $Pkg
Ok "package.json atualizado (scripts build/start/start:pm2)."

# 4) tsconfig básico (se faltar)
$Tsconfig = Join-Path $Root "tsconfig.json"
if(-not (Test-Path $Tsconfig)){
  Info "Criando tsconfig.json (básico)…"
  @"
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "outDir": "dist",
    "rootDir": ".",
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "strict": false,
    "skipLibCheck": true,
    "sourceMap": false
  },
  "include": ["apps/**/*", "packages/**/*", "src/**/*"]
}
"@ | Set-Content -Encoding UTF8 $Tsconfig
  Ok "tsconfig.json criado."
}

# 5) ecosystem.config.js (rodando build JS — mais leve que ts-node)
$Eco = Join-Path $Root "ecosystem.config.js"
Info "Escrevendo ecosystem.config.js (JS build, cluster $Instances)…"
Backup $Eco
@"
module.exports = {
  apps: [{
    name: "meu-app",
    script: "./dist/apps/api/src/server.js",
    exec_mode: "cluster",
    instances: $Instances,
    env: {
      NODE_ENV: "production",
      LOG_LEVEL: "info"
    },
    max_memory_restart: "350M"
  }]
};
"@ | Set-Content -Encoding UTF8 $Eco
Ok "ecosystem.config.js pronto."

# 6) Garantir libs necessárias
Info "Instalando dependências necessárias (typescript, prom-client, on-finished)…"
npm i -D typescript | Out-Null
npm i prom-client on-finished | Out-Null

# 7) Build e (re)start com PM2
Info "Compilando TypeScript (npm run build)…"
npm run build | Out-Null

Info "Reiniciando app no PM2…"
& $npx pm2 delete meu-app 2>$null | Out-Null
& $npx pm2 start ecosystem.config.js | Out-Null
& $npx pm2 save | Out-Null

# 8) Subir/atualizar Prometheus+Grafana (se tiver docker-compose)
if(Test-Path $Compose){
  Info "Subindo Prometheus e Grafana (docker compose up -d)…"
  docker compose up -d | Out-Null
}

# 9) Testes rápidos
Start-Sleep -Seconds 3
Info "Testando métricas:"
try {
  $pm2Ok = (Invoke-WebRequest -Uri "http://localhost:$Pm2Port/metrics" -UseBasicParsing -TimeoutSec 5).StatusCode -eq 200
} catch { $pm2Ok = $false }

try {
  $apiOk = (Invoke-WebRequest -Uri "http://localhost:$ApiPort/internal/metrics" -UseBasicParsing -TimeoutSec 5).StatusCode -eq 200
} catch { $apiOk = $false }

if($pm2Ok){ Ok "PM2 exporter OK → http://localhost:$Pm2Port/metrics" } else { Warn "PM2 exporter NÃO respondeu na porta $Pm2Port" }
if($apiOk){ Ok "API metrics OK  → http://localhost:$ApiPort/internal/metrics" } else { Warn "API /internal/metrics NÃO respondeu na porta $ApiPort" }

# 10) Mostrar estado final
& $npx pm2 status
Write-Host ""
Ok "Pronto! Prometheus scrape em pm2:$Pm2Port e api:$ApiPort. Grafana em http://localhost:3000 (admin/admin)."
