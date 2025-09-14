param(
  [string]$Folder = ".",
  [switch]$Fix,
  [string]$ReportPath = ".\audit-report.json"
)

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
  Write-Host "🔧 Instalando PSScriptAnalyzer..." -ForegroundColor Yellow
  Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
}

$all = Get-ChildItem -Path $Folder -Recurse -Filter *.ps1
$results = @()

foreach ($f in $all) {
  Write-Host "📄 Analisando: $($f.FullName)" -ForegroundColor Cyan
  $issues = Invoke-ScriptAnalyzer -Path $f.FullName -Severity Warning,Error
  $results += $issues
  if ($Fix) {
    try {
      Invoke-ScriptAnalyzer -Path $f.FullName -Fix | Out-Null
      Write-Host "✅ Corrigido (quando possível)." -ForegroundColor Green
    } catch {
      Write-Warning "Falha ao corrigir: $($_.Exception.Message)"
    }
  }
}

# exporta relatório
$results | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 $ReportPath
Write-Host "`n📄 Relatório: $ReportPath" -ForegroundColor Yellow

# sai com código de erro se houver problemas (útil p/ CI)
if ($results.Count -gt 0 -and -not $Fix) { exit 1 } else { exit 0 }
