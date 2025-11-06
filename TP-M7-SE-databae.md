# TP pratique – Database Secrets Engine


1. Préprer votre environement du vault-raft:

```
export VAULT_ADDR=http://localhost:8200
```
```
vault login <token>
```

*  démarrer une database prosgres
```
docker run --rm -d \
  --name postgres_vault \
  -e POSTGRES_USER=vaultuser \
  -e POSTGRES_PASSWORD=vaultpass \
  -e POSTGRES_DB=vaultdb \
  -p 5432:5432 \
  postgres:16
```

2. Activez le moteur de secrets database.

```
vault secrets enable database
```

3. Configurez Vault avec le plugin et les informations de connexion appropriés.

```
vault write database/config/my-postgresql-database \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="*" \
    connection_url="postgresql://{{username}}:{{password}}@host.docker.internal:5432/vaultdb?sslmode=disable" \
    username="vaultuser" \
    password="vaultpass" \
    password_authentication="scram-sha-256"
```

4. Configurez un rôle qui associe un nom dans Vault à une instruction SQL à exécuter pour créer les informations d'identification de la base de données.


```
vault write database/roles/my-role-db \
    db_name="my-postgresql-database" \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"
```


5. Generate a new credential


