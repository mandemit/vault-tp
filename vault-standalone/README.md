# vault-standalone

openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
  -keyout vault.key -out vault.crt \
  -subj "/C=FR/ST=IDF/L=Paris/O=Vault/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,DNS:vault,DNS:vault-std"