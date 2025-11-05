# TP pratique – Policies

## Policie Admin

1. Créer une policie admin policies/admin.hcl et l'afecter a l'utilisateur student (userpass auth) 

```
export VAULT_ADDR=http://localhost:8200
vault login <token>
```

```
export VAULT_ADDR=http://localhost:8200
vault login <token>
```
```
vault policy write admin policies/admin.hcl
```

2. Créer l'utilisateur `dev` avec la methode d'authentification (userpass) avec la policie dev 

3. Faite de meme pour l'utilsateur `ops`
