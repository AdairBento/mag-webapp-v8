# Vehicles - Interações & Realtime

Assina:

- vehicle.updated.v1
- maintenance.scheduled.v1

Interações:

- Filtro status (available|rented|maintenance)
- Ação "Agendar manutenção" -> envia comando API, aguarda `maintenance.scheduled.v1`
