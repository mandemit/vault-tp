# Lecture et écriture dans le namespace de dev
path "secret/data/dev/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Accès restreint aux secrets partagés
path "secret/data/shared/*" {
  capabilities = ["read", "list"]
}

# Pas d'accès aux policies ou système
path "sys/*" {
  capabilities = ["deny"]
}
