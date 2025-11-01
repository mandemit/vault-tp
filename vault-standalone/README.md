# vault-raft

## 🚀 Démarrage

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

* Vault: [http://localhost:8400]()

## 🔧 Initialisation du cluster
* Initialise Vault seulement sur le premier nœud :

```
docker exec -it vault vault operator init |tee key.txt
```

Garde les 5 Unseal Keys et le Root Token.


* Se connecter sur le conteneur 

```
docker exec -it vault sh
```

* Déverrouille Vault1 : (3 fois avec 3 clés différentes)

```
vault operator unseal
```

* Connecte-toi avec le Root Token :

```
vault login <root_token>
```

* Vérifie le cluster

```
vault status
```
Tu devrais obtenir un tableau du genre
```
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.18.5
Build Date      2025-02-24T09:40:28Z
Storage Type    file
Cluster Name    vault-std
Cluster ID      9b281a35-b633-7bbc-ee11-4f3d131372e3
HA Enabled      false
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
token                hvs.CAESIHEqPj3EdGIHr8tdvFm6dVEAgiVTYqWFa_JCSpS8PUMCGh4KHGh2cy5PVFh3U1JJNlhqa1YyYkVmZnNCa3hLZk4
token_accessor       9Q0Mw6yz8coDFgvAalqTyVNJ
token_duration       768h
token_renewable      true
token_policies       ["autounseal" "default"]
identity_policies    []
policies             ["autounseal" "default"]
```


## Configurer le cluster vault-raft avec seal transit

```
cd ../vault-raft
```

* Arréter du cluster 

```
docker compose down
```

* Supprimer  les datas

```
rm -rf data
```

* Configurer le seal transit sur tout les configutration des 3 noeud 

```
seal "transit" {
  address = "http://host.docker.internal:8400"
  token = "hvs.CAESIHEqPj3EdGIHr8tdvFm6dVEAgiVTYqWFa_JCSpS8PUMCGh4KHGh2cy5PVFh3U1JJNlhqa1YyYkVmZnNCa3hLZk4"
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"
}
```


* Démarrage  

```
docker compose down -d
```

* Initialisation 

```
docker exec -it vault1 vault operator init |tee key.txt
```

* Ajoute les autres nœuds au cluster Raft :

```
docker exec -it vault2 vault operator raft join http://vault1:8200
docker exec -it vault3 vault operator raft join http://vault1:8200
```

* Vérifie  le cluster

```
docker exec -it vault1 vault operator raft list-peers
```