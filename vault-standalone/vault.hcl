
ui = true
cluster_name = "vault-std"

listener "tcp" {
  address     = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_cert_file = "/vault/tls/vault.crt"
  tls_key_file  = "/vault/tls/vault.key"
  tls_disable_client_certs = true
  # tls_disable = 1
}

storage "file" {
  path = "/vault/data"
}

api_addr = "https://vault:8200"
cluster_addr = "https://vault:8201"
disable_mlock = true
log_level = "debug"
