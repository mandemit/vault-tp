# vault-standalone

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

* Déverrouille Vault : (3 fois avec 3 clés différentes)

```
docker exec -it vault vault operator unseal
```

* Connecte-toi avec le Root Token :

```
docker exec -it vault vault login <root_token>
# ou en local 
export VAULT_ADDR=http://localhost:8400
vault login <root_token>
```

* Vérifie  le cluster


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
