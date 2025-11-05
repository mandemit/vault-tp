# TP pratique – Authentification Userpass

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
role_id    f2bf3c93-eaed-dc68-c9aa-155b42f871b7
```
* SecretID

```
vault write -f auth/approle/role/myapp-role/secret-id
```
Exemple de sortie
```
Key                   Value
---                   -----
secret_id             6dc52da8-83cd-29ca-a4e4-7fab99240f1a
secret_id_accessor    8c2cdb10-3652-5a55-ac9f-a5e81393bd89
secret_id_num_uses    0
secret_id_ttl         1h
```

5. Se connecter :

```
vault write auth/approle/login \
  role_id="f2bf3c93-eaed-dc68-c9aa-155b42f871b7" \
  secret_id="6dc52da8-83cd-29ca-a4e4-7fab99240f1a"
```
Exemple de sortie
```
Key                     Value
---                     -----
token                   hvs.CAESIGvqHfnSH10JlKZlCE2m-PmpEPXzv1dVvo5dPGh40Wr7Gh4KHGh2cy5JTWxYb0J0ZTRNR1RWTkNsRGNqYVJ0aE8
token_accessor          tu3i3b0ZlGGWp5yn3Cqxl4ia
token_duration          30m
token_renewable         true
token_policies          ["default"]
identity_policies       []
policies                ["default"]
token_meta_role_name    myapp-role
```
