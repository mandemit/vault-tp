# TP pratique – Transit Secrets Engine


1. Préprer votre environement du vault-raft:

```
export VAULT_ADDR=http://localhost:8200
```
```
vault login <token>
```

2. Activer le moteur de secrets Transit

```
vault secrets enable transit
```

3. Créer la clé de chiffrement

```
vault write -f transit/keys/app
```

4. Créer les policies pour l’encryptage et le décryptage
   * Policy pour le chiffrement
```
vault policy write transit-encrypt-app -<<EOF
path "transit/encrypt/app" {
   capabilities = [ "update" ]
}
EOF
```
   * Policy pour le déchiffrement
```
vault policy write transit-decrypt-app -<<EOF
path "transit/decrypt/app" {
   capabilities = [ "update" ]
}
EOF
```

5. Créer deux utilisateurs avec la méthode `userpass` 
  * app-a avec la policy `transit-encrypt-app`
  * app-b avec la policy `transit-decrypt-app`

6. Se connecter avec app-a et chiffrer vos données 

```
vault login -method=userpass username="app-a" password="formation"
export VAULT_TOKEN=<token>
```
```
vault write -f transit/encrypt/app plaintext=$(echo toto |base64)
```
Résultat attendu : 
```
Key            Value
---            -----
ciphertext     vault:v1:2Z48AZ74Hljg/Lh4Ti1dXdQ9UvcUxoQ2w5YD1w/TdrqD
key_version    1
```

7. Dans un autre terminal, se connecter avec app-b et déchiffrer les données

```
vault login -method=userpass username="app-a" password="formation"
export VAULT_TOKEN=<token>
```

```
vault write -f transit/decrypt/app ciphertext=vault:v1:2Z48AZ74Hljg/Lh4Ti1dXdQ9UvcUxoQ2w5YD1w/TdrqD
```
Résultat attendu : 
```
Key          Value
---          -----
plaintext    dG90bwo=
```