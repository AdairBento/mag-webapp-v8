# Redis Patterns
- Keys: `tenant:{id}:entity:{type}:{id}`
- TTLs: catálogo 600s, read-model 30s
- Anti-dogpile: lock (setnx+ttl) durante recomputação