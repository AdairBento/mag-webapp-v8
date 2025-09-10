# contar-arquivos.ps1
param([string]$BasePath = ".\mag-webapp-v8-integrated")
Write-Host "🔎 Gerando relatório de arquivos em $BasePath..." -ForegroundColor Cyan
if (-Not (Test-Path $BasePath)) { Write-Host "❌ Caminho não encontrado: $BasePath" -ForegroundColor Red; exit 1 }
$resultado = Get-ChildItem -Path $BasePath -Recurse -File | Group-Object { $_.DirectoryName } | Sort-Object Count -Descending | ForEach-Object {
  [PSCustomObject]@{ Pasta = $_.Name.Replace($BasePath,"").Trim("\"); Arquivos = $_.Count }
}
$resultado | Format-Table -AutoSize
$csvPath = Join-Path $BasePath "relatorio-arquivos.csv"
$txtPath = Join-Path $BasePath "relatorio-arquivos.txt"
$resultado | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
$resultado | Out-File -FilePath $txtPath -Encoding UTF8
Write-Host "✅ Relatório gerado:`n - $csvPath`n - $txtPath" -ForegroundColor Green
