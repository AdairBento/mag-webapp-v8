param([int]$Port = 3000)
$ErrorActionPreference = "Stop"
$Root   = (Get-Location).Path
$ApiSrc = Join-Path $Root "apps/api/src"
$Index  = Join-Path $ApiSrc "index.js"

# Injeta middleware simples de Basic Auth no index.js
$AuthBlock = @'
function basicAuth(req, res, next) {
  const u = process.env.INTERNAL_USER || "admin";
  const p = process.env.INTERNAL_PASS || "admin";
  const h = req.headers["authorization"] || "";
  if (!h.startsWith("Basic ")) return res.status(401).set("WWW-Authenticate","Basic").end("Auth required");
  const [, b64] = h.split(" ");
  const [user, pass] = Buffer.from(b64, "base64").toString("utf8").split(":");
  if (user === u && pass === p) return next();
  return res.status(403).json({ error: "forbidden" });
}
'@

# Garante presença do bloco e aplica em /internal
$content = Get-Content $Index -Raw
if ($content -notmatch 'function basicAuth') {
  $content = $content -replace 'app.use\(express\.json\(\)\);\s*', "app.use(express.json());`r`n$AuthBlock`r`n"
}
if ($content -notmatch 'app\.use\("/internal", basicAuth,') {
  $content = $content -replace 'app\.use\("/internal", require\("\.\/ui\/internal"\)\);',
    'app.use("/internal", basicAuth, require("./ui/internal"));'
}
Set-Content -Path $Index -Value $content -Encoding UTF8

# Variáveis (ajuste no seu ambiente)
$env:INTERNAL_USER = "mag"
$env:INTERNAL_PASS = "locacao"

# Reinicia
try {
  $pids = (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue |
    Select-Object -Expand OwningProcess -Unique)
  foreach ($pid in $pids) { Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue }
} catch {}
$env:PORT = $Port
Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList @("/c","npm","run","dev") -WorkingDirectory $Root
Start-Sleep -Seconds 2

# Teste sem credenciais (deve pedir auth)
try { Invoke-RestMethod "http://localhost:$Port/internal/health" -TimeoutSec 5 }
catch { "[OK] Sem credenciais bloqueou: $($_.Exception.Message)" }

# Teste com credenciais (deve passar)
$pair = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("mag:locacao"))
Invoke-RestMethod "http://localhost:$Port/internal/health" -Headers @{Authorization="Basic $pair"} -TimeoutSec 5
