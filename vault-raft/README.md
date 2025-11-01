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


## 🔧 Initialisation du cluster
* Initialise Vault seulement sur le premier nœud :

```
docker exec -it vault1 vault operator init
```
example de sortie
```
Unseal Key 1: PC+7gcusLGkaCQ9cllS0eZ88B4KAHuHMOQu6Elt/Jlr8
Unseal Key 2: 29VEnm3FIh9BVDxHqvcrahK6DVL5RDKiXYSixhf15ixF
Unseal Key 3: FJtLo7MgOy2vlQLfYNtYK5QqY3Q19oL3a94rYybtaKEp
Unseal Key 4: nkwVMkvwaTi6rm8j/W5S0VYBCh+MYJZKKL0Gg7wd8BhX
Unseal Key 5: VznF27F02er5Ct5/lvzH6OKrEt+F1l9O6qXLV6rb0/CP

Initial Root Token: hvs.PMZ3pqXpQgl9hkHC0HYMH3tc

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 3 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

Garde les 5 Unseal Keys et le Root Token.

* Déverrouille Vault1 : (3 fois avec 3 clés différentes)

```
docker exec -it vault1 vault operator unseal
```

* Connecte-toi avec le Root Token :

```
docker exec -it vault1 vault login <root_token>
# ou en local 
vault login <root_token>
```

* Vérifie  le cluster

```
docker exec -it vault1 vault operator raft list-peers
# ou en local 
vault operator raft list-peers
```
Tu devrais obtenir un tableau du genre
```
Node      Address        State       Voter
----      -------        -----       -----
vault1    vault1:8201    leader      true
```

## Ajoute les autres nœuds au cluster Raft :

* Ajout du nœud vault2
```
docker exec -e VAULT_ADDR='http://vault2:8200' -it vault2 vault operator raft join http://vault1:8200
```

* Ajout du nœud vault3
```
docker exec -e VAULT_ADDR='http://vault3:8200' -it vault3 vault operator raft join http://vault1:8200

```

## Déverrouille les autres nœuds 

* Déverrouille Vault2  (3 fois avec 3 clés différentes)

```
docker exec -e VAULT_ADDR='http://vault2:8200' -it vault2 vault operator unseal
```

* Déverrouille Vault3  (3 fois avec 3 clés différentes)

```
docker exec -e VAULT_ADDR='http://vault3:8200' -it vault3 vault operator unseal
```




## Vérifie  le cluster

```
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
