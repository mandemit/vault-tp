
ui = true
cluster_name = "vault-std"

listener "tcp" {
  address     = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = 1
}

storage "file" {
  path = "/vault/data"
}

api_addr = "http://vault:8200"
cluster_addr = "http://vault:8201"
disable_mlock = true
