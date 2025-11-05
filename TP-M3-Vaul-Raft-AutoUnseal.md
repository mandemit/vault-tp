# vault-raft

## Configurer le cluster vault-raft avec seal transit du cluster vault-standalone

* Preparer l'environnement

```
export VAULT_ADDR='https://localhost:8400'
export VAULT_SKIP_VERIFY=true

vault login <token-root-vault-std>
```

* Enable and configure transit secrets engine

```
vault secrets enable transit
vault write -f transit/keys/autounseal
```

* Create an autounseal policy

```
vault policy write autounseal -<<EOF
path "transit/encrypt/autounseal" {
   capabilities = [ "update" ]
}

path "transit/decrypt/autounseal" {
   capabilities = [ "update" ]
}
EOF
```

* Créer un token dédié qui accéde a cette policie

```
vault token create -policy=autounseal
```

```
Key                  Value
---                  -----
token                hvs.CAESIATOda77mmnZxi2u4JkXAbYRXwCNyL-JgexbSoZpTRzwGh4KHGh2cy51NlR3UjN2aTBkeXVHQUNQRjhQTzZHSk4
token_accessor       oKEZuhYYVpVw9rqY5ANMR4Yv
token_duration       768h
token_renewable      true
token_policies       ["autounseal" "default"]
identity_policies    []
policies             ["autounseal" "default"]
```

* Configurer le seal transit sur tout les configutration des 3 noeud 

  - vault-raft/config/vault1.hcl
  - vault-raft/config/vault2.hcl
  - vault-raft/config/vault3.hcl

```
seal "transit" {
  address = "https://host.docker.internal:8400"
  token = "hvs.CAESIATOda77mmnZxi2u4JkXAbYRXwCNyL-JgexbSoZpTRzwGh4KHGh2cy51NlR3UjN2aTBkeXVHQUNQRjhQTzZHSk4"
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"
}
```

## 🚀 Démarrage

```
cd vault-raft
```

```
docker compose up -d
```

```
docker compose ps
```

```
docker compose logs
```

## URL 

* Vault: [http://localhost:8200]()

## 🔧 Initialisation du cluster
* Initialisation 

```
docker compose exec -it vault1 vault operator init |tee key.txt
```

* Ajoute les autres nœuds au cluster Raft :

```
docker compose exec -it vault2 vault operator raft join http://vault1:8200
docker compose exec -it vault3 vault operator raft join http://vault1:8200
```


## Vérifie  le cluster

```
export VAULT_ADDR='http://localhost:8200'
vault login <token>
vault operator raft list-peers
```
* Tu devrais obtenir un tableau du genre :
```
Node      Address        State       Voter
----      -------        -----       -----
vault1    vault1:8201    leader      true
vault2    vault2:8201    follower    true
vault3    vault3:8201    follower    true
```
