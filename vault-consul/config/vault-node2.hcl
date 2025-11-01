storage "consul" {
  address = "consul:8500"
  path    = "vault/"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://vault-node2:8200"
cluster_addr = "http://vault-node2:8201"

ui = true
