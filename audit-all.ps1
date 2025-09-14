#Requires -Version 7.0
[CmdletBinding()]
param(
  [switch]$SkipNpmCi,
  [switch]$SkipOptionalTools
)

$ErrorActionPreference = "Stop"
$Root    = Get-Location
$Reports = Join-Path $Root "reports"
New-Item -ItemType Directory -Force -Path $Reports | Out-Null

function SafeRun([string]$name, [scriptblock]$block){
  try { & $block } catch { Write-Warning "[$name] falhou: $($_.Exception.Message)" }
}
function WriteStep($t){ Write-Host "`n=== $t ===" -ForegroundColor Cyan }
function HasTool($name, $args="--version"){
  try { (& $name $args) | Out-Null; return $true } catch { return $false }
}

# ---------- 0) Inventário ----------
WriteStep "Inventário"
(Get-ChildItem -Force -Recurse -Depth 6 |
  Select-Object FullName, Length, LastWriteTime |
  Sort-Object FullName) | Out-File (Join-Path $Reports "__inventory_tree.txt") -Encoding UTF8

if(Test-Path package.json){ Get-Content package.json -Raw | Out-File (Join-Path $Reports "__package_root.json") -Encoding UTF8 }
Get-ChildItem -Recurse -Filter package.json | ForEach-Object { "==> $($_.FullName)"; Get-Content $_.FullName -Raw } |
  Out-File (Join-Path $Reports "__packages_all.txt") -Encoding UTF8

# ---------- 1) Detectores ----------
$IsNode   = Test-Path "$Root/package.json"
$ApiDir   = Join-Path $Root "apps/api"
$HasApi   = Test-Path $ApiDir
$SrcDir   = if(Test-Path "$ApiDir/src"){ "$ApiDir/src" } else { "$ApiDir" }
$Schema   = Join-Path $ApiDir "prisma\schema.prisma"

# ---------- 2) Desbloqueio Prisma (Windows) ----------
WriteStep "Desbloqueio Prisma (Windows)"
$dll = "$Root\node_modules\.prisma\client\query_engine-windows.dll.node"
$clientDir = "$Root\node_modules\.prisma\client"
SafeRun "Kill node"   { Get-Process node   -ErrorAction SilentlyContinue | Stop-Process -Force }
SafeRun "Kill prisma" { Get-Process prisma -ErrorAction SilentlyContinue | Stop-Process -Force }

if (Test-Path $dll) {
  SafeRun "attrib -R" { attrib -R $dll }
  SafeRun "takeown"   { takeown /F $dll   2>$null }
  SafeRun "icacls"    { icacls $dll /grant "$env:USERNAME:(F)" 2>$null }
  SafeRun "rm dll"    { Remove-Item $dll -Force }
}
if (Test-Path $clientDir) {
  $bak = "$clientDir.__old__$(Get-Date -Format yyyyMMddHHmmss)"
  SafeRun "rename .prisma\\client" { Rename-Item $clientDir $bak }
  SafeRun "cleanup bak"            { Remove-Item -Recurse -Force $bak }
}

# ---------- 3) ESLint ----------
WriteStep "ESLint"
$eslintJson = Join-Path $Reports "eslint.json"
if($IsNode){
  if(-not $SkipNpmCi){
    SafeRun "npm ci" { npm ci --ignore-scripts }
  } else {
    Write-Host "→ SkipNpmCi: pulando npm ci" -ForegroundColor Yellow
  }

  # tenta gerar prisma antes do lint (evita erros de import)
  if(Test-Path $Schema){
    SafeRun "prisma generate" { npx prisma generate --schema="$Schema" }
  }

  SafeRun "eslint" { npx eslint . -f json | Out-File $eslintJson -Encoding UTF8 }
} else {
  Write-Warning "Projeto sem package.json; pulando ESLint."
}

# ---------- 4) Hotspots (regex) ----------
WriteStep "Hotspots (regex)"
$hotspotsCsv = Join-Path $Reports "hotspots.csv"
$patterns = @(
  @{ Name="console.log";     Pattern="console\.log\(";                                     Hint="Trocar por logger (Pino) com reqId" }
  @{ Name="any-catch-empty"; Pattern="catch\s*\(\s*.\s*\)\s*\{\s*\}";                      Hint="Catch vazio oculta erro" }
  @{ Name="promise-no-await";Pattern="=\s*prisma\.\w+\.\w+\(";                             Hint="Chamada Prisma sem await?" }
  @{ Name="unsafe-eval";     Pattern="\beval\s*\(";                                        Hint="Evitar eval" }
  @{ Name="string-concat-sql";Pattern="(SELECT|INSERT|UPDATE|DELETE).*\+.*";               Hint="Concatenação de SQL" }
  @{ Name="res-send-twice";  Pattern="res\.(json|send|end)\(.*\).*\n.*res\.(json|send)";  Hint="Duplo envio de resposta" }
  @{ Name="no-return-async"; Pattern="async\s+\w+\s*\([^)]*\)\s*\{\s*(?!.*return).*";     Hint="Async sem return pode ocultar erro" }
  @{ Name="todo-fixme";      Pattern="(//\s*TODO|//\s*FIXME)";                             Hint="Pendência no código" }
  @{ Name="bypass-tenant";   Pattern="x-tenant-id|tenantId";                               Hint="Checar middleware e validação de tenant" }
  @{ Name="cors-star";       Pattern="origin:\s*['""]\*['""]";                             Hint="CORS * em produção" }
  @{ Name="helmet";          Pattern="helmet\(";                                          Hint="Helmet aplicado?" }
  @{ Name="zod-or-joi";      Pattern="\b(z\.|Joi\.)";                                     Hint="Validação de input presente?" }
  @{ Name="try-catch";       Pattern="try\s*\{";                                          Hint="Cobertura de try/catch" }
)
"rule,file,line,match,hint" | Out-File $hotspotsCsv -Encoding UTF8
Get-ChildItem -Recurse -Include *.js,*.mjs,*.cjs -Path $Root | ForEach-Object {
  $file = $_.FullName
  $text = Get-Content $file -Raw -ErrorAction SilentlyContinue
  if(-not $text){ return }
  foreach($p in $patterns){
    $m = Select-String -InputObject $text -Pattern $p.Pattern -AllMatches
    foreach($mm in $m){
      $line = $mm.LineNumber
      $frag = ($mm.Line.Trim().Replace('"','""'))
      "$($p.Name),$file,$line,""$frag"",""$($p.Hint)""" | Add-Content $hotspotsCsv
    }
  }
}

# ---------- 5) Mapa de rotas ----------
WriteStep "Mapa de rotas"
$routesCsv = Join-Path $Reports "routes_map.csv"
"file,method,path,line" | Out-File $routesCsv -Encoding UTF8
$routesPattern = "(router|app)\.(get|post|put|patch|delete)\s*\(\s*['""]([^'""]+)['""]"
Get-ChildItem -Recurse -Include *.routes.js,*.js -Path $SrcDir -ErrorAction SilentlyContinue | ForEach-Object {
  $file = $_.FullName
  $matches = Select-String -Path $file -Pattern $routesPattern -AllMatches
  foreach($m in $matches){
    $method = $m.Matches[0].Groups[2].Value.ToUpper()
    $path   = $m.Matches[0].Groups[3].Value
    "$file,$method,$path,$($m.LineNumber)" | Add-Content $routesCsv
  }
}

# ---------- 6) Tenant & validação ----------
WriteStep "Tenant & validação"
$tenantReport = Join-Path $Reports "tenant_validation.txt"
$middlewareHit = Select-String -Path (Get-ChildItem -Recurse -Include *.js -Path $SrcDir) -Pattern "x-tenant-id|tenantId" -AllMatches
$zodHit        = Select-String -Path (Get-ChildItem -Recurse -Include *.js -Path $SrcDir) -Pattern "\bz\." -AllMatches
$joiHit        = Select-String -Path (Get-ChildItem -Recurse -Include *.js -Path $SrcDir) -Pattern "\bJoi\." -AllMatches
"== Tenant header occurrences =="  | Out-File $tenantReport -Encoding UTF8
$middlewareHit | ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" } | Add-Content $tenantReport
"`n== Zod occurrences =="          | Add-Content $tenantReport
$zodHit | ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" } | Add-Content $tenantReport
"`n== Joi occurrences =="          | Add-Content $tenantReport
$joiHit | ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" } | Add-Content $tenantReport

# ---------- 7) Prisma ----------
WriteStep "Prisma"
if(Test-Path $Schema){
  SafeRun "prisma format"  { npx prisma format --schema="$Schema" | Out-Null }
  $prismaCsv = Join-Path $Reports "prisma_usage.csv"
  "file,line,pattern" | Out-File $prismaCsv -Encoding UTF8
  $prismaPatterns = @(
    @{ P="prisma\.\w+\.\w+\(";     H="Uso de client" },
    @{ P="prisma\.\$transaction";  H="Transação" },
    @{ P="include\s*:\s*\{";       H="N+1? (avaliar includes)" }
  )
  Get-ChildItem -Recurse -Include *.js -Path $SrcDir | ForEach-Object {
    $file = $_.FullName
    $text = Get-Content $file -Raw
    foreach($pp in $prismaPatterns){
      $m = Select-String -InputObject $text -Pattern $pp.P -AllMatches
      foreach($mm in $m){
        "$file,$($mm.LineNumber),$($pp.H)" | Add-Content $prismaCsv
      }
    }
  }
} else {
  Write-Warning "schema.prisma não encontrado em $Schema"
}

# ---------- 8) Segurança HTTP ----------
WriteStep "Segurança HTTP"
$secTxt = Join-Path $Reports "http_security.txt"
$helmet = Select-String -Path (Get-ChildItem -Recurse -Include *.js -Path $SrcDir) -Pattern "helmet\(" -AllMatches
$cors   = Select-String -Path (Get-ChildItem -Recurse -Include *.js -Path $SrcDir) -Pattern "cors\("   -AllMatches
"== Helmet ==" | Out-File $secTxt -Encoding UTF8
$helmet | ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" } | Add-Content $secTxt
"`n== CORS ==" | Add-Content $secTxt
$cors   | ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" } | Add-Content $secTxt

# ---------- 9) Extras opcionais ----------
WriteStep "Ferramentas opcionais"
if(-not $SkipOptionalTools){
  if(HasTool "semgrep" "--version"){ SafeRun "Semgrep" { semgrep --config auto --json --timeout 180 | Out-File (Join-Path $Reports "semgrep.json") -Encoding UTF8 } }
  if(HasTool "gitleaks" "version"){ SafeRun "Gitleaks"{ gitleaks detect --report-format json --report-path (Join-Path $Reports "gitleaks.json") } }
  if(HasTool "trivy" "--version"){ SafeRun "TrivyFS" { trivy fs . --format json -o (Join-Path $Reports "trivy-fs.json") } }
} else {
  Write-Host "→ SkipOptionalTools: pulando Semgrep/Gitleaks/Trivy" -ForegroundColor Yellow
}

# ---------- 10) Síntese ----------
WriteStep "Síntese Markdown"
$md = Join-Path $Reports "AUDIT_SUMMARY.md"
@"
# Auditoria completa — $((Split-Path -Leaf $Root))

## 1) Inventário
- \`__inventory_tree.txt\`, \`__packages_all.txt\`

## 2) ESLint
- \`eslint.json\` (problemas por arquivo/linha)

## 3) Hotspots
- \`hotspots.csv\` (rule,file,line,match,hint)

## 4) Rotas
- \`routes_map.csv\` (file,method,path,line)

## 5) Tenant/Validação
- \`tenant_validation.txt\`

## 6) Prisma
- \`prisma_usage.csv\`

## 7) Segurança HTTP
- \`http_security.txt\`

## 8) Extras
- Semgrep/Gitleaks/Trivy se habilitados

"@ | Out-File $md -Encoding UTF8

Write-Host "`n✅ Concluído. Relatórios em: $Reports" -ForegroundColor Green
