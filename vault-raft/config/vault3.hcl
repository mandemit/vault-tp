
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

# seal "transit" {
#   address = "http://172.17.0.1:8400"
#   token = "hvs.CAESIHEqPj3EdGIHr8tdvFm6dVEAgiVTYqWFa_JCSpS8PUMCGh4KHGh2cy5PVFh3U1JJNlhqa1YyYkVmZnNCa3hLZk4"
#   disable_renewal = "false"
#   key_name = "autounseal"
#   mount_path = "transit/"
#   tls_skip_verify = "true"
# }
