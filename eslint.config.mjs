import js from "@eslint/js";
import pluginImport from "eslint-plugin-import";
import pluginN from "eslint-plugin-n";
import pluginPromise from "eslint-plugin-promise";

export default [
  {
    // arquivos/dirs a ignorar
    ignores: [
      "**/node_modules/**",
      "**/dist/**",
      "**/build/**",
      "**/coverage/**",
      "**/audit-reports/**",
      "eslint.config.*",
      "scripts/**/*.ps1",
      "apps/api/src/index.backup-helpers.js",
    ],
  },
  js.configs.recommended,
  {
    files: ["**/*.js", "**/*.cjs"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "commonjs",
      globals: {
        require: "readonly",
        module: "readonly",
        process: "readonly",
        console: "readonly",
        __dirname: "readonly",
        __filename: "readonly",
      },
    },
    plugins: { import: pluginImport, n: pluginN, promise: pluginPromise },
    rules: {
      "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
      "import/no-unresolved": "off",
      "n/no-missing-import": "off",
      "promise/no-nesting": "off",
    },
  },
,
  {
    languageOptions: { ecmaVersion: "latest", globals: { URL: "readonly", fetch: "readonly" } },
    env: { node: true }
  }
].filter(Boolean);
