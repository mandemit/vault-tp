pid_file = "/tmp/vault-agent.pid"
log_level = "info"

vault {
  address = "http://vault.example.com:8200"
  retry {
    num_retries = 5
  }
}

auto_auth {
   method {
      type = "token_file"
      config = {
         token_file_path = "./agent/token"
      }
   }

}


template {
    error_on_missing_key = true
  contents = <<EOH
{{ with secret "database/creds/my-role-db" }}
DB_USERNAME="{{ .Data.username }}"
DB_PASSWORD="{{ .Data.password }}"
{{ end }}
EOH
  destination = "./agent/db-creds.env"
  command     = "echo $(date) - credentials renewed >> agent/db-creds.trace"
}

cache {

}
