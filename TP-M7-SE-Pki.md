# TP pratique – Transit Secrets Engine


1. Préprer votre environement du vault-raft:

```
export VAULT_ADDR=http://localhost:8200
```
```
vault login <token>
```

2. Activez le moteur de secrets PKI.

```
vault secrets enable pki
```

3. Configurez le moteur de secrets PKI pour émettre des certificats avec une durée de vie maximale (TTL) de 87 600 heures.

```
vault secrets tune -max-lease-ttl=87600h pki
```

4. Générez l'autorité de certification racine mondomain.com, donnez-lui un issuer name et enregistrez son certificat dans le fichier root_2025_ca.crt.

```
vault write -field=certificate pki/root/generate/internal \
     common_name="mondomain.com" \
     issuer_name="Root-CA" \
     ttl=87600h > root_2025_ca.crt

```

5. Exécutez la commande suivante pour générer un CSR intermédiaire et l'enregistrer sous le nom pki_intermediate.csr. 

```
vault write -format=json pki/intermediate/generate/internal \
     common_name="mondomain.com Intermediate CA" \
     issuer_name="Intermediate-CA" \
     | jq -r '.data.csr' > pki_intermediate.csr
```

6. Signez le certificat intermédiaire avec la clé privée de root CA et enregistrez le certificat généré sous le nom intermediate.cert.pem.

```
vault write -format=json pki/root/sign-intermediate \
     issuer_ref="Root-CA" \
     csr=@pki_intermediate.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > intermediate.cert.pem

```

7. Une fois la CSR signée et le certificat renvoyé par le root CA, celui-ci peut être réimporté dans Vault.

```
vault write pki/intermediate/set-signed certificate=@intermediate.cert.pem
```
Résultat attendu : 

```
Key                 Value
---                 -----
existing_issuers    [574a7244-aacd-3059-fd74-d667e99a0635]
existing_keys       <nil>
imported_issuers    [0f9d882b-ea94-cd68-831f-a2abd598681a]
imported_keys       <nil>
mapping             map[0f9d882b-ea94-cd68-831f-a2abd598681a:f3aea6d6-2d7a-255e-8a79-cc87fd7fdb11 574a7244-aacd-3059-fd74-d667e99a0635:5808b6a1-e544-6ccd-7eb4-4926db660732]
```

8. Recupérer le `imported_issuers` pour fixer le issuer_name=Intermediate-CA

```
vault write pki/issuer/0f9d882b-ea94-cd68-831f-a2abd598681a issuer_name=Intermediate-CA
```

9. Changer le default issuers à Intermediate-CA

```
vault write pki/config/issuers default=Intermediate-CA
```


10. Créez un rôle nommé mondomain-com qui autorise les sous-domaines et spécifiez l'ID de référence de l'émetteur par défaut comme valeur de issuer_ref.

```
vault write pki/roles/example-dot-com \
     issuer_ref=Intermediate-CA \
     allowed_domains="example.com" \
     allow_subdomains=true \
     max_ttl="720h"
```


11. Créer vos certificat depuis ce role 