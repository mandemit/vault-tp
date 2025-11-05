# TP pratique – Authentification Certificat



1. Préprer votre environement et du vault-standalone:

```
export VAULT_ADDR=https://localhost:8400
export VAULT_SKIP_VERIFY=true
```
```
vault login <token-root-vault-std>
```
2. Monter le moteur de secret cert:

```
vault auth enable cert
```

3. Ajouter le role my-app avec l'autorité de certificat ca.crt et le CN=serveur1

```
vault write auth/cert/certs/my-app \
    display_name="serveur1" \
    policies="default" \
    allowed_common_names="serveur1" \
    certificate=@vault-standalone/tls/ca.crt
```

4. Utilier le certificat serveur1 avec sa clé pour effectuer l'authentification 

```
curl -k -X POST --cert vault-standalone/tls/serveur1.crt \
    --key vault-standalone/tls/serveur1.key --data '{"name": "my-app"}' \
    https://localhost:8400/v1/auth/cert/login |jq
```

