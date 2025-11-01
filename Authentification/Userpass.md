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
vault auth enable userpass
```

3. Créer un utilisateur:

```
vault write auth/userpass/users/student password="formation" policies="default"
```

4. Se connecter :

```
vault login -method=userpass username="student" password="formation"
```

5. Vérifier le token :

```
vault token lookup
```

6. Se connecter de puis l'ui [http://localhost:8200/ui/vault/auth?with=userpass]()