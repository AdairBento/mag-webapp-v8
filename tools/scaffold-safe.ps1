param([switch]$Apply)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Raízes
$Root    = (Get-Location).Path
$ApiRoot = Join-Path $Root "apps\api"

# util
$Changes = New-Object System.Collections.Generic.List[pscustomobject]
function Add-Change([string]$Action,[string]$Path,[string]$Reason){
  $Changes.Add([pscustomobject]@{ Action=$Action; Path=$Path; Reason=$Reason })
}
function Show-Preview(){
  "`n=== PREVIEW ({0}) ===`n" -f ($(if($Apply){"apply"}else{"dry-run"})) | Write-Host
  $Changes | Sort-Object Action,Path | Format-Table -AutoSize
}
function Ensure-Dir($p){ if(-not (Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null } }
function Write-NewFile([string]$Path,[string]$Content,[string]$Reason="novo arquivo"){
  if(Test-Path $Path){ Add-Change "Skip" $Path "já existe (ok)"; return }
  Add-Change "Create" $Path $Reason
  if($Apply){ Ensure-Dir (Split-Path $Path); Set-Content -Encoding UTF8 -Path $Path -Value $Content }
}
function Update-File([string]$Path,[ScriptBlock]$Transform,[string]$Reason="update"){
  if(-not (Test-Path $Path)){ Add-Change "Skip" $Path "não encontrado"; return }
  $orig = Get-Content $Path -Raw
  $new  = & $Transform $orig
  if([string]::Equals($orig,$new)){ Add-Change "Skip" $Path "sem mudanças" }
  else { Add-Change "Update" $Path $Reason; if($Apply){ Set-Content -Encoding UTF8 -Path $Path -Value $new } }
}

# ===== conteúdos =====
$MW_RequestId = @'
import { Request, Response, NextFunction } from "express";
import { randomUUID } from "crypto";
export default function requestId(req: Request, res: Response, next: NextFunction) {
  const id = randomUUID();
  (req as any).id = id;
  res.setHeader("X-Request-Id", id);
  next();
}
'@
$MW_Error = @'
import { Request, Response, NextFunction } from "express";
import logger from "../utils/logger";
export default function errorHandler(err: any, _req: Request, res: Response, _next: NextFunction) {
  const errorId = (res.getHeader("X-Request-Id") || "no-id").toString();
  const status = err?.status || 500;
  const payload = { errorId, message: status === 500 ? "Erro interno" : err?.message || "Erro" };
  logger.error({ errorId, err }, "request failed");
  res.status(status).json(payload);
}
'@
$Utils_Logger = @'
const logger = {
  info:  (...args: any[]) => console.log("[INFO]",  ...args),
  warn:  (...args: any[]) => console.warn("[WARN]", ...args),
  error: (...args: any[]) => console.error("[ERROR]", ...args),
  debug: (...args: any[]) => console.debug("[DEBUG]", ...args),
};
export default logger;
export { logger };
'@
$Service_Locacao = @'
export function validarCPF(cpf: string): boolean { return /^\d{11}$/.test(cpf); }
'@
$Service_Manutencao = @'
export function statusValido(status: string): boolean { return ["pendente","concluida"].includes(status); }
'@
$Service_Financeiro = @'
export function calcularJuros(valor: number, dias: number): number { const taxa = 0.02; return valor + (valor * taxa * dias); }
'@
$Router_Locacao = @'
import { Router } from "express";
import { validarCPF } from "../../../services/locacaoService";
import logger from "../../../utils/logger";
const router = Router();
router.get("/ping", (_req, res) => res.json({ module: "locacao", pong: true }));
router.post("/registrar", (req, res) => {
  const { cpf } = req.body || {};
  if (!validarCPF(String(cpf || ""))) return res.status(400).json({ error: "CPF inválido" });
  logger.info("CPF validado");
  res.json({ ok: true, msg: "Locação registrada" });
});
export default router;
'@
$Router_Manutencao = @'
import { Router } from "express";
import { statusValido } from "../../../services/manutencaoService";
import logger from "../../../utils/logger";
const router = Router();
router.get("/ping", (_req, res) => res.json({ module: "manutencao", pong: true }));
router.post("/ordem", (req, res) => {
  const { status } = req.body || {};
  if (!statusValido(String(status || ""))) return res.status(400).json({ error: "Status inválido" });
  logger.info(`Ordem marcada como ${status}`);
  res.json({ ok: true, status });
});
export default router;
'@
$Router_Financeiro = @'
import { Router } from "express";
import { calcularJuros } from "../../../services/financeiroService";
import logger from "../../../utils/logger";
const router = Router();
router.get("/ping", (_req, res) => res.json({ module: "financeiro", pong: true }));
router.post("/cobranca", (req, res) => {
  const { valor, diasAtraso } = req.body || {};
  const v = Number(valor || 0), d = Number(diasAtraso || 0);
  if (!isFinite(v) || !isFinite(d)) return res.status(400).json({ error: "Parâmetros inválidos" });
  const total = calcularJuros(v, d);
  logger.info({ total }, "Cobrança gerada");
  res.json({ ok: true, total });
});
export default router;
'@
$Test_Locacao = @'
import request from "supertest"; import express from "express"; import router from "../src/ui/v1/locacao";
const app = express(); app.use(express.json()); app.use("/v1/locacao", router);
it("locacao ping", async () => { await request(app).get("/v1/locacao/ping").expect(200); });
it("locacao registrar invalido", async () => { await request(app).post("/v1/locacao/registrar").send({ cpf: "123" }).expect(400); });
it("locacao registrar ok", async () => { await request(app).post("/v1/locacao/registrar").send({ cpf: "12345678901" }).expect(200); });
'@
$Test_Manutencao = @'
import request from "supertest"; import express from "express"; import router from "../src/ui/v1/manutencao";
const app = express(); app.use(express.json()); app.use("/v1/manutencao", router);
it("manutencao ping", async () => { await request(app).get("/v1/manutencao/ping").expect(200); });
it("manutencao status invalido", async () => { await request(app).post("/v1/manutencao/ordem").send({ status: "x" }).expect(400); });
it("manutencao status ok", async () => { await request(app).post("/v1/manutencao/ordem").send({ status: "pendente" }).expect(200); });
'@
$Test_Financeiro = @'
import request from "supertest"; import express from "express"; import router from "../src/ui/v1/financeiro";
const app = express(); app.use(express.json()); app.use("/v1/financeiro", router);
it("financeiro ping", async () => { await request(app).get("/v1/financeiro/ping").expect(200); });
it("financeiro cobranca invalida", async () => { await request(app).post("/v1/financeiro/cobranca").send({ valor: "a", diasAtraso: 2 }).expect(400); });
it("financeiro cobranca ok", async () => { await request(app).post("/v1/financeiro/cobranca").send({ valor: 100, diasAtraso: 5 }).expect(200); });
'@
$Script_GenDocs = @'
import express from "express";
import list from "express-list-endpoints";
import internal from "../src/ui/internal";
import v1 from "../src/ui/v1";
const app = express();
app.use("/internal", internal);
app.use("/v1", v1);
const endpoints = list(app);
console.log("# Rotas da API");
for (const e of endpoints) console.log(`- \`${e.path}\` — ${e.methods.join(", ")}`);
'@

# ===== criar arquivos =====
Write-NewFile (Join-Path $ApiRoot "src\middleware\requestId.ts") $MW_RequestId "novo arquivo"
Write-NewFile (Join-Path $ApiRoot "src\middleware\error.ts")     $MW_Error     "novo arquivo"
Write-NewFile (Join-Path $ApiRoot "src\utils\logger.ts")         $Utils_Logger "novo arquivo"
Write-NewFile (Join-Path $ApiRoot "src\services\locacaoService.ts")     $Service_Locacao     "service do módulo"
Write-NewFile (Join-Path $ApiRoot "src\services\manutencaoService.ts")  $Service_Manutencao  "service do módulo"
Write-NewFile (Join-Path $ApiRoot "src\services\financeiroService.ts")  $Service_Financeiro  "service do módulo"
Write-NewFile (Join-Path $ApiRoot "src\ui\v1\locacao\index.ts")    $Router_Locacao    "router do módulo"
Write-NewFile (Join-Path $ApiRoot "src\ui\v1\manutencao\index.ts") $Router_Manutencao "router do módulo"
Write-NewFile (Join-Path $ApiRoot "src\ui\v1\financeiro\index.ts") $Router_Financeiro "router do módulo"
Write-NewFile (Join-Path $ApiRoot "test\locacao.test.ts")    $Test_Locacao    "teste de rota Supertest"
Write-NewFile (Join-Path $ApiRoot "test\manutencao.test.ts") $Test_Manutencao "teste de rota Supertest"
Write-NewFile (Join-Path $ApiRoot "test\financeiro.test.ts") $Test_Financeiro "teste de rota Supertest"
Write-NewFile (Join-Path $ApiRoot "scripts\gendocs.ts") $Script_GenDocs "novo arquivo"

# ===== package.json (criando key com dois-pontos corretamente) =====
$PkgPath = Join-Path $ApiRoot "package.json"
if(Test-Path $PkgPath){
  $pkg = Get-Content $PkgPath -Raw | ConvertFrom-Json
  if(-not $pkg.PSObject.Properties.Name -contains "scripts"){
    $pkg | Add-Member -NotePropertyName "scripts" -NotePropertyValue ([pscustomobject]@{}) -Force
  }
  $Pairs = @(
    @{ k="dev";        v="tsx src/start.ts" },
    @{ k="build";      v="tsc -p tsconfig.json" },
    @{ k="start";      v="node dist/start.js" },
    @{ k="test";       v="vitest run" },
    @{ k="doc:routes"; v="tsx scripts/gendocs.ts" }
  )
  $changed = $false
  foreach($pair in $Pairs){
    $prop = $pkg.scripts.PSObject.Properties | Where-Object { $_.Name -eq $pair.k }
    if(-not $prop){
      $pkg.scripts | Add-Member -NotePropertyName $pair.k -NotePropertyValue $pair.v -Force
      $changed = $true
    } elseif($prop.Value -ne $pair.v){
      $pkg.scripts | Add-Member -NotePropertyName $pair.k -NotePropertyValue $pair.v -Force
      $changed = $true
    }
  }
  if($changed){
    Add-Change "Update" $PkgPath "scripts adicionados (dev/build/start/test/doc:routes)"
    if($Apply){ ($pkg | ConvertTo-Json -Depth 50) | Set-Content -Encoding UTF8 -Path $PkgPath }
  } else {
    Add-Change "Skip" $PkgPath "scripts já presentes"
  }
} else {
  Add-Change "Skip" $PkgPath "package.json não encontrado"
}

# ===== injeta módulos no v1/index.ts (sem sobrescrever) =====
$V1Index = Join-Path $ApiRoot "src\ui\v1\index.ts"
if(Test-Path $V1Index){
  Update-File $V1Index {
    param($text)
    $new = $text
    $imports = @('import locacao from "./locacao";','import manutencao from "./manutencao";','import financeiro from "./financeiro";')
    foreach($imp in $imports){
      if($new -notmatch [regex]::Escape($imp)){
        if($new -match '(^import .*;$([\r\n]+))+'){
          $last = [regex]::Matches($new, '(^import .*;$)','Multiline') | Select-Object -Last 1
          if($last){ $idx = $last.Index + $last.Length; $new = $new.Substring(0,$idx) + "`r`n$imp" + $new.Substring($idx) }
          else { $new = "$imp`r`n$new" }
        } else { $new = "$imp`r`n$new" }
      }
    }
    $uses = @('router.use("/locacao", locacao);','router.use("/manutencao", manutencao);','router.use("/financeiro", financeiro);')
    foreach($u in $uses){
      if($new -notmatch [regex]::Escape($u)){
        if($new -match 'export\s+default\s+router\s*;'){ $new = $new -replace '(export\s+default\s+router\s*;)', "$u`r`n`$1" }
        else { $new = $new + "`r`n$u`r`n" }
      }
    }
    return $new
  } "inserir imports e router.use dos módulos"
} else {
  Add-Change "Conflict" $V1Index "arquivo não-gerenciado; não será sobrescrito"
}

# Informar arquivos que não tocamos
foreach($c in @((Join-Path $ApiRoot "src\server.ts"),(Join-Path $ApiRoot "src\start.ts"),(Join-Path $ApiRoot "src\ui\internal.ts"))){
  if(Test-Path $c){ Add-Change "Conflict" $c "arquivo não-gerenciado; não será sobrescrito" }
}

# saída
Show-Preview
if($Apply){
  "`n✅ Mudanças aplicadas." | Write-Host -ForegroundColor Green
  "Dica: no apps/api, garanta dev-deps:  npm i -D vitest supertest tsx express-list-endpoints @types/supertest" | Write-Host -ForegroundColor Yellow
  if(-not (Get-Command tsc -ErrorAction SilentlyContinue)){ "tsc não encontrado (ok, opcional)." | Write-Host -ForegroundColor DarkGray }
} else {
  "`nNenhuma mudança aplicada. Rode com:  pwsh tools\scaffold-safe.ps1 -Apply" | Write-Host -ForegroundColor Yellow
}
