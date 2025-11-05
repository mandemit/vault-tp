# CA

# 1. Crée une CA
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -days 3650 -out ca.crt \
  -subj "/C=FR/ST=IDF/L=Paris/O=Vault/CN=VaultCA"

# 2. Crée le certificat serveur signé par la CA
openssl genrsa -out vault.key 2048
openssl req -new -key vault.key -out vault.csr \
  -subj "/C=FR/ST=IDF/L=Paris/O=Vault/CN=vault"
openssl x509 -req -in vault.csr -CA ca.crt -CAkey ca.key \
  -CAcreateserial -out vault.crt -days 365

# 3. Crée le certificat client signé par la CA
openssl genrsa -out serveur1.key 2048
openssl req -new -key serveur1.key -out serveur1.csr \
  -subj "/C=FR/ST=IDF/L=Paris/O=Vault/CN=serveur1"
openssl x509 -req -in serveur1.csr -CA ca.crt -CAkey ca.key \
  -CAcreateserial -out serveur1.crt -days 365