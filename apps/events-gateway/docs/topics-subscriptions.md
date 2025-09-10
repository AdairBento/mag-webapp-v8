# Tópicos e Assinaturas (Gateway Realtime)

## Canais por página (UI)

- **Dashboard**
  - `ui.dashboard.kpis.v1`
  - `notification.created.v1`

- **Vehicles**
  - `vehicle.updated.v1`
  - `maintenance.scheduled.v1`

- **Rentals**
  - `rental.created.v1`
  - `rental.overdue.v1`
  - `rental.closed.v1`
  - `payment.captured.v1`
  - `payment.failed.v1`

- **Clients**
  - `contract.signed.v1`
  - `notification.sent.v1`

- **Finance**
  - `invoice.generated.v1`
  - `payment.captured.v1`
  - `payment.failed.v1`

## Convenções
- Cabeçalho de contexto: `x-tenant-id`, `x-user-id`, `x-trace-id`
- Partição: por `tenantId`
- Idempotência: `eventId` único
- Versão de payload: sufixo `.v1`