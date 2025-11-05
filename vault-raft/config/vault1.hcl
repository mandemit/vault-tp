
ui = true
cluster_name = "vault-raft"

listener "tcp" {
  address     = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = 1
}

storage "raft" {
  path = "/vault/data"
  node_id = "vault1"
}

api_addr = "http://vault1:8200"
cluster_addr = "http://vault1:8201"
disable_mlock = true

seal "transit" {
  address = "https://host.docker.internal:8400"
  token = "hvs.CAESIATOda77mmnZxi2u4JkXAbYRXwCNyL-JgexbSoZpTRzwGh4KHGh2cy51NlR3UjN2aTBkeXVHQUNQRjhQTzZHSk4"
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"
}