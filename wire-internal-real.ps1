param([int]$Port = 3000)
$ErrorActionPreference = "Stop"
$Root   = (Get-Location).Path
$ApiSrc = Join-Path $Root "apps/api/src"
$UiDir  = Join-Path $ApiSrc "ui/internal"
$UiIdx  = Join-Path $UiDir "index.js"

# Novo conteúdo do router: tenta usar services/clientService.getClients({ tenantId })
$RouterContent = @'
const { Router } = require("express");
const router = Router();

// Health mantido
router.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});
router.get("/health/extended", require("../../health-extended"));

// Tentativa de usar o serviço real; fallback em caso de erro ou ausência
router.get("/clients", async (req, res) => {
  const { tenantId } = req.query;
  try {
    let service;
    try {
      service = require("../../services/clientService"); // exporta getClients
    } catch (e) {
      // serviço não existe ainda; cai no stub
    }

    if (service?.getClients) {
      const data = await service.getClients({ tenantId, page: 1, limit: 50 });
      const count = Array.isArray(data) ? data.length : (data?.count ?? 0);
      return res.json({ data: Array.isArray(data) ? data : (data?.rows ?? []), count });
    }

    // Fallback demo
    return res.json({
      data: [
        { id: "demo-1", name: "Cliente Interno DEMO 1", tenantId: tenantId ?? "N/A" },
        { id: "demo-2", name: "Cliente Interno DEMO 2", tenantId: tenantId ?? "N/A" }
      ],
      count: 2
    });
  } catch (err) {
    console.error("[/internal/clients] error:", err);
    res.status(500).json({ error: "internal_error", message: String(err?.message || err) });
  }
});

module.exports = router;
'@
Set-Content -Path $UiIdx -Value $RouterContent -Encoding UTF8

# Reinicia API (mata porta + sobe)
try {
  $pids = (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue |
    Select-Object -Expand OwningProcess -Unique)
  foreach ($pid in $pids) { Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue }
} catch {}
$env:PORT = $Port
Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList @("/c","npm","run","dev") -WorkingDirectory $Root
Start-Sleep -Seconds 2

# Smoke
function T([string]$u){ try{ $r=Invoke-RestMethod $u -TimeoutSec 8; "`nOK: $u"; $r|ConvertTo-Json -Depth 6 }catch{ "FAIL: $u"; $_.Exception.Message } }
T "http://localhost:$Port/internal/clients?tenantId=022d0c59-4363-4993-a485-9adf29719824"
