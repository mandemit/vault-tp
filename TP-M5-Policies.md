# TP pratique – Policies

## Policie Admin

1. Créer une policie admin policies/admin.hcl et l'afecter a l'utilisateur student (userpass auth) 

```
export VAULT_ADDR=http://localhost:8200
vault login <token>
```

```
vault policy write admin policies/admin.hcl

vault write auth/userpass/users/student policies="admin"
```

```
vault login -method=userpass username="student" password="formation"
```

```
Key                    Value
---                    -----
token                  hvs.CAESIO1O7R11IxKSexXS2T_6YSxOi2F-5U4FrPVG3Gh-l37MGh4KHGh2cy5kZXZkT0FnbjF4alFyeTRxcFdUWVJaSU0
token_accessor         ERondk5NHfqacUmGtvhEnHa8
token_duration         768h
token_renewable        true
token_policies         ["admin" "default"]
identity_policies      []
policies               ["admin" "default"]
token_meta_username    student
```

2. Créer l'utilisateur `dev` avec la methode d'authentification (userpass) avec la policie dev 

3. Faite de meme pour l'utilsateur `ops`

4. Créer un token tonemporaire avec tout les privilèges 

```
vault policy write break-glass policies/break-glass.hcl
vault token create -ttl=180s -explicit-max-ttl=5m -policy=break-glass
```
