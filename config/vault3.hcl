
ui = true
cluster_name = "vault-raft"

listener "tcp" {
  address     = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = 1
}

storage "raft" {
  path = "/vault/data"
  node_id = "vault3"
}

api_addr = "http://vault3:8200"
cluster_addr = "http://vault3:8201"
disable_mlock = true
