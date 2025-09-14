# na raiz do projeto
New-Item -ItemType Directory -Force -Path scripts | Out-Null
Set-Content -Path scripts/setup-dev.ps1 -Value (Get-Clipboard) -Encoding UTF8   # cole o script copiado
# ou salve o arquivo manualmente

# executar
powershell -ExecutionPolicy Bypass -File scripts/setup-dev.ps1

