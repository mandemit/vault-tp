# TP pratique – Authentification AppRole

1. Préprer votre environement et du vault-raft:

```
export VAULT_ADDR=http://localhost:8200
```
```
vault login <token>
```

2. Activer la méthode:

```
vault auth enable approle
```

3. Créer un AppRole:

```
vault write auth/approle/role/myapp-role token_policies="default" secret_id_ttl=60m token_ttl=30m token_max_ttl=60m
```

4. Récupérer RoleID et SecretID:

* RoleID

```
vault read auth/approle/role/myapp-role/role-id
```
Exemple de sortie
```
Key        Value
---        -----
role_id    b8241ad0-63dc-a187-7199-f5dabcc95978
```
* SecretID

```
vault write -f auth/approle/role/myapp-role/secret-id
```
Exemple de sortie
```
Key                   Value
---                   -----
secret_id             84f62dc3-068b-442a-cac7-3e9950575a0f
secret_id_accessor    68d9fb08-3d76-37f4-dd8b-c1d1b65e7c3e
secret_id_num_uses    0
secret_id_ttl         1h
```

5. Se connecter :

```
vault write auth/approle/login \
  role_id="b8241ad0-63dc-a187-7199-f5dabcc95978" \
  secret_id="84f62dc3-068b-442a-cac7-3e9950575a0f"
```
Exemple de sortie
```
Key                     Value
---                     -----
token                   hvs.CAESILtESOapg7xMXx5cnfnddhHimADupDWsIug5UoTJmOBjGh4KHGh2cy5LaXVlcjlXdnQ0UWdOMG5UQzBuV1JiTGo
token_accessor          m8sjrsW0Mc52f92xy4q2dT4U
token_duration          30m
token_renewable         true
token_policies          ["default"]
identity_policies       []
policies                ["default"]
token_meta_role_name    myapp-role
```
