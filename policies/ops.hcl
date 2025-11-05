# Lecture et mise à jour des secrets applicatifs
path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Accès lecture-only aux health endpoints
path "sys/health" {
  capabilities = ["read"]
}

# Accès aux logs d’audit pour diagnostic
path "sys/audit/*" {
  capabilities = ["read", "list"]
}

# Aucune modification des policies ou auth
path "sys/policies/*" {
  capabilities = ["read", "list"]
}
