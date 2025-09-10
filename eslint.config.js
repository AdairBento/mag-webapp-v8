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
      sourceType: "script",
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
