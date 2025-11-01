# vault-consul-tp

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

## 🔧 Initialisation du cluster
* Initialise Vault seulement sur le premier nœud :

```
docker exec -it vault-node1 vault operator init -key-shares=3 -key-threshold=2
```
example de sortie
```
Unseal Key 1: F6IwsDpXCd1GoNdYGFAei+oeQDNJ8P2r8D02fl8Uot2A
Unseal Key 2: 5adbOaz7fH1IGcUBh5jx9czAhE/G3JQN3hoWC80HQARN
Unseal Key 3: jAeUqfGnXrqT07PU4fAVrGBed1aWKxsKaZZ6KRBRH3qF

Initial Root Token: hvs.NgNaIXjS2fhzaqw7WZrGqUu4

Vault initialized with 3 key shares and a key threshold of 2. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 2 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 2 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

Garde les 3 Unseal Keys et le Root Token.

* Déverrouille vault-node1 : (2 fois avec 2 clés différentes)

```
docker exec -it vault-node1 vault operator unseal
```

* Connecte-toi avec le Root Token :

```
docker exec -it vault-node1 vault login <root_token>
# ou en local 
vault login <root_token>
```

* Vérifie  le cluster

```
docker exec -it vault-node1 vault status
```
Tu devrais obtenir un tableau du genre
```
ey             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    3
Threshold       2
Version         1.18.5
Build Date      2025-02-24T09:40:28Z
Storage Type    consul
Cluster Name    vault-cluster-594ed362
Cluster ID      ebe0b051-a3b5-1c85-78d1-2439af649bbd
HA Enabled      true
HA Cluster      https://vault-node1:8201
HA Mode         active
Active Since    2025-10-31T14:27:58.453483377Z
```

## Déverrouille les autres nœuds 

* Déverrouille du nœud vault-node2
```
docker exec -it vault-node2 vault operator unseal <key>
docker exec -it vault-node2 vault operator unseal <key>
```

* Déverrouille du nœud vault-node3
```
docker exec -it vault-node3 vault operator unseal <key>
docker exec -it vault-node3 vault operator unseal <key>
```



## Vérification du cluster

```
docker exec -it vault-node1 vault status
```
* Résultat attendu :
```
HA Enabled      true
HA Cluster      https://vault-node1:8201
HA Mode         active
Active Since    2025-10-31T14:27:58.453483377Z
```
* Sur les autres:
```
HA Enabled             true
HA Cluster             https://vault-node1:8201
HA Mode                standby
Active Node Address    http://vault-node1:8200
```
