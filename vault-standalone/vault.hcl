
ui = true
# cluster_name = "vault-std"

listener "tcp" {
  address     = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_cert_file = "/vault/tls/vault.crt"
  tls_key_file  = "/vault/tls/vault.key"
  tls_ca_file   = "/vault/tls/ca.crt"
}

storage "file" {
  path = "/vault/data"
}


