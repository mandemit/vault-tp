# Lecture des logs d’audit
path "sys/audit/*" {
  capabilities = ["read", "list"]
}

# Lecture des policies pour vérification
path "sys/policies/acl/*" {
  capabilities = ["read", "list"]
}

# Lecture des informations de santé
path "sys/health" {
  capabilities = ["read"]
}

# Interdiction d’écrire ou modifier
path "*" {
  capabilities = ["deny"]
}
