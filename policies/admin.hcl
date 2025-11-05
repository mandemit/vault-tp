# Accès complet aux systèmes internes
path "sys/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Gestion des policies
path "sys/policies/acl/*" {
  capabilities = ["create", "update", "read", "list", "delete"]
}

# Gestion des méthodes d’authentification
path "auth/*" {
  capabilities = ["create", "update", "read", "list", "delete"]
}

# Gestion des secrets engines (montage, suppression)
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Gestion des tokens (rotation, suppression)
path "auth/token/*" {
  capabilities = ["create", "update", "read", "delete", "list"]
}
