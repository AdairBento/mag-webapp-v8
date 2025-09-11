# Retry Policies

- Estratégia: Exponential backoff + jitter
- Tentativas: 3
- Backoff base: 200 ms (máx 2 s)
- Condições de retry: 5xx, timeouts, ECONNRESET. **Sem retry** em 4xx.
- Idempotência: obrigatória (chave de dedupe por comando/evento)
