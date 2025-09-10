param(
  [string]$ProjectPath = ".",
  [switch]$SkipInstall # Use this if you only want to write/merge files without npm install/husky
)

$ErrorActionPreference = "Stop"

function Write-Info($msg) { Write-Host "[INFO]" -ForegroundColor Cyan -NoNewline; Write-Host " $msg" }
function Write-Done($msg) { Write-Host "[OK]" -ForegroundColor Green -NoNewline; Write-Host " $msg" }
function Write-Warn($msg) { Write-Host "[WARN]" -ForegroundColor Yellow -NoNewline; Write-Host " $msg" }
function Ensure-Dir($p) { if(-not (Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null } }

Push-Location $ProjectPath
try {
  if(-not (Test-Path "package.json")){
    throw "Não encontrei package.json em '$ProjectPath'. Abra o PowerShell na raiz do projeto ou passe -ProjectPath corretamente."
  }

  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"

  # 1) Backup e carregar package.json
  Copy-Item "package.json" "package.backup-eslint-$stamp.json" -Force
  $pkgText = Get-Content "package.json" -Raw -Encoding UTF8
  $pkg = $pkgText | ConvertFrom-Json

  if(-not $pkg.scripts){ $pkg | Add-Member -Name scripts -Value (@{}) -MemberType NoteProperty }
  if(-not $pkg.devDependencies){ $pkg | Add-Member -Name devDependencies -Value (@{}) -MemberType NoteProperty }

  function Ensure-Script([string]$name, [string]$value){
    if(-not $pkg.scripts.PSObject.Properties.Name.Contains($name)){
      $pkg.scripts | Add-Member -Name $name -Value $value -MemberType NoteProperty
      Write-Info "scripts.$name adicionado"
    } else {
      Write-Info "scripts.$name já existe (mantido)"
    }
  }

  # 2) Scripts essenciais
  Ensure-Script "lint" "eslint ."
  Ensure-Script "lint:fix" "eslint . --fix"
  Ensure-Script "lint:check" "eslint . --max-warnings 0"
  Ensure-Script "format" "prettier . --write"
  Ensure-Script "format:check" "prettier . --check"
  Ensure-Script "fix-all" "npm run lint:fix && npm run format"

  if((Test-Path "apps/api/src/index.js") -and -not $pkg.scripts.PSObject.Properties.Name.Contains("debug:api")){
    Ensure-Script "debug:api" "node --inspect apps/api/src/index.js"
  }

  # 3) lint-staged
  if(-not $pkg.PSObject.Properties.Name.Contains("lint-staged")){
    $ls = @{
      "*.{js,mjs,cjs,ts,tsx,json,md}" = @("prettier --write","eslint --fix")
    }
    $pkg | Add-Member -Name "lint-staged" -Value $ls -MemberType NoteProperty
    Write-Info "lint-staged adicionado"
  } else {
    # Garante o glob principal
    $glob = "*.{js,mjs,cjs,ts,tsx,json,md}"
    if(-not $pkg.'lint-staged'.PSObject.Properties.Name.Contains($glob)){
      $pkg.'lint-staged' | Add-Member -Name $glob -Value @("prettier --write","eslint --fix") -MemberType NoteProperty
      Write-Info "lint-staged: glob padrão adicionado"
    } else {
      Write-Info "lint-staged existente (mantido)"
    }
  }

  # 4) DevDependencies
  $deps = @{
    "eslint" = "^9.19.0"
    "@eslint/js" = "^9.19.0"
    "eslint-config-prettier" = "^9.1.0"
    "eslint-plugin-import" = "^2.30.0"
    "eslint-plugin-n" = "^17.13.2"
    "eslint-plugin-promise" = "^7.1.0"
    "prettier" = "^3.3.3"
    "husky" = "^9.1.6"
    "lint-staged" = "^15.2.10"
  }
  foreach($k in $deps.Keys){
    if(-not $pkg.devDependencies.PSObject.Properties.Name.Contains($k)){
      $pkg.devDependencies | Add-Member -Name $k -Value $deps[$k] -MemberType NoteProperty
      Write-Info "devDependencies.$k @ $($deps[$k])"
    } else {
      Write-Info "devDependencies.$k já existe (mantido)"
    }
  }

  # 5) Salvar package.json
  ($pkg | ConvertTo-Json -Depth 20) | Set-Content "package.json" -Encoding UTF8
  Write-Done "package.json atualizado (backup em package.backup-eslint-$stamp.json)"

  # 6) Renomear .eslintrc* se existirem (evitar conflito)
  Get-ChildItem -Path . -Filter ".eslintrc*" -File -ErrorAction SilentlyContinue | ForEach-Object {
    $new = "$($_.FullName).backup-$stamp"
    Rename-Item $_.FullName $new -ErrorAction SilentlyContinue
    Write-Warn "Antigo $($_.Name) renomeado para $(Split-Path $new -Leaf)"
  }

  # 7) Criar/atualizar eslint.config.js (sourceType conforme package.json.type)
  $sourceType = "script"
  if($pkg.type -eq "module"){ $sourceType = "module" }

  $eslintConfig = @"
// eslint.config.js — ESLint v9 Flat Config (instalado via script)
import { defineConfig, globalIgnores } from "eslint/config";
import js from "@eslint/js";
import n from "eslint-plugin-n";
import promise from "eslint-plugin-promise";
import importPlugin from "eslint-plugin-import";
import prettier from "eslint-config-prettier";

export default defineConfig([
  globalIgnores(["node_modules","dist","build",".prisma","coverage"]),
  {
    files: ["**/*.{js,mjs,cjs}"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "$sourceType",
    },
    plugins: { n, promise, import: importPlugin },
    extends: [js.configs.recommended],
    rules: {
      "no-unused-vars": ["warn", { "argsIgnorePattern": "^_", "varsIgnorePattern": "^_" }],
      "eqeqeq": ["error", "always"],
      "promise/catch-or-return": "warn",
      "import/order": ["warn", { "newlines-between": "always", "alphabetize": { "order": "asc" } }],
      "n/no-missing-import": "error",
      "n/no-missing-require": "error",
      "comma-dangle": ["error", "always-multiline"],
      "semi": ["error", "always"],
      "quotes": ["error", "double", { "avoidEscape": true }]
    },
  },
  // apps/web geralmente ESM (Vite/Next) — ajuste se necessário
  {
    files: ["apps/web/**/*.{js,mjs,cjs}"],
    languageOptions: { sourceType: "module" }
  },
  // Prettier por último
  prettier,
]);
"@

  Set-Content "eslint.config.js" $eslintConfig -Encoding UTF8
  Write-Done "eslint.config.js criado/atualizado"

  # 8) Prettier
  if(-not (Test-Path ".prettierrc.json")){
    $prettier = @"
{
  "printWidth": 100,
  "tabWidth": 2,
  "singleQuote": false,
  "semi": true,
  "trailingComma": "all",
  "arrowParens": "always",
  "endOfLine": "lf",
  "bracketSpacing": true,
  "bracketSameLine": false
}
"@
    Set-Content ".prettierrc.json" $prettier -Encoding UTF8
    Write-Done ".prettierrc.json criado"
  } else {
    Write-Info ".prettierrc.json já existe (mantido)"
  }

  if(-not (Test-Path ".prettierignore")){
    @"
node_modules
dist
build
coverage
"@ | Set-Content ".prettierignore" -Encoding UTF8
    Write-Done ".prettierignore criado"
  } else {
    Write-Info ".prettierignore já existe (mantido)"
  }

  # 9) VS Code settings (não sobrescreve se já existir)
  Ensure-Dir ".vscode"
  if(-not (Test-Path ".vscode/settings.json")){
    @"
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "explicit"
  },
  "eslint.useFlatConfig": true,
  "eslint.validate": [
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact"
  ],
  "files.eol": "\n"
}
"@ | Set-Content ".vscode/settings.json" -Encoding UTF8
    Write-Done ".vscode/settings.json criado"
  } else {
    Write-Info ".vscode/settings.json já existe (mantido — verifique chaves recomendadas)"
  }

  # 10) Husky + lint-staged
  if(-not $SkipInstall){
    Write-Info "Instalando dependências (npm install)..."
    npm install

    Write-Info "Inicializando Husky (npx husky init)..."
    npx husky init | Out-Null

    $preCommitPath = ".husky/pre-commit"
    @"
#!/usr/bin/env sh
. "\$(dirname -- "\$0")/_/husky.sh"

echo "🔎 Running lint-staged..."
npx lint-staged
"@ | Set-Content $preCommitPath -Encoding UTF8 -NoNewline
    Write-Done "Hook .husky/pre-commit atualizado"
  } else {
    Write-Warn "Pulei npm install e husky init por causa do -SkipInstall"
  }

  # 11) Script utilitário
  if(-not (Test-Path "tools")){ New-Item -ItemType Directory -Force -Path "tools" | Out-Null }
  @"
param(
  [string]$Path = "."
)

$ErrorActionPreference = "Stop"
Write-Host "▶ Executando ESLint --fix em $Path ..."
npx eslint $Path --fix
Write-Host "▶ Formatando com Prettier ..."
npx prettier $Path --write
Write-Host "✅ Concluído. Agora validando..."
npx eslint $Path
npx prettier $Path --check
Write-Host "👌 Sem erros pendentes (ou foram reportados acima)."
"@ | Set-Content "tools/lint-fix-all.ps1" -Encoding UTF8
  Write-Done "tools/lint-fix-all.ps1 criado"

  Write-Host ""
  Write-Done "Integração concluída."
  Write-Host "Use: npm run fix-all  |  npm run lint:check  |  npm run debug:api" -ForegroundColor Magenta
}
finally {
  Pop-Location
}
