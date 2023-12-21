# TP7 SECU : Accès réseau sécurisé

# I. VPN

🌞 **Monter un serveur VPN Wireguard sur `vpn.tp7.secu`**

Conf VPN :

```bash
[gwuill@vpn-tp7-secu ~]$ sudo cat /etc/wireguard/wg0.conf
[Interface]
Address = 10.7.2.0/24
SaveConfig = false
PostUp = firewall-cmd --zone=public --add-masquerade
PostUp = firewall-cmd --add-interface=wg0 --zone=public
PostDown = firewall-cmd --zone=public --remove-masquerade
PostDown = firewall-cmd --remove-interface=wg0 --zone=public
ListenPort = 13337
PrivateKey = gPk[...]NlI=

[Peer]
PublicKey = 8K8A91T[...]CZeI8jQ=
AllowedIPs = 10.7.2.11/32

[Peer]
PublicKey = TPZnKHp[...]BzMIWQxM=
AllowedIps = 10.7.2.100/32
```


```bash
[gwuill@vpn-tp7-secu ~]$ sudo systemctl status wg-quick@wg0
● wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0
     Loaded: loaded (/usr/lib/systemd/system/wg-quick@.service; disabled; preset: disabled)
     Active: active (exited) since Thu 2023-12-14 16:55:27 CET; 5min ago
       Docs: man:wg-quick(8)
             man:wg(8)
             https://www.wireguard.com/
             https://www.wireguard.com/quickstart/
             https://git.zx2c4.com/wireguard-tools/about/src/man/wg-quick.8
             https://git.zx2c4.com/wireguard-tools/about/src/man/wg.8
    Process: 1309 ExecStart=/usr/bin/wg-quick up wg0 (code=exited, status=0/SUCCESS)
   Main PID: 1309 (code=exited, status=0/SUCCESS)
        CPU: 244ms

Dec 14 16:55:26 vpn-tp7-secu systemd[1]: Starting WireGuard via wg-quick(8) for wg0...
Dec 14 16:55:26 vpn-tp7-secu wg-quick[1309]: [#] ip link add wg0 type wireguard
Dec 14 16:55:26 vpn-tp7-secu wg-quick[1309]: [#] wg setconf wg0 /dev/fd/63
Dec 14 16:55:26 vpn-tp7-secu wg-quick[1309]: [#] ip -4 address add 10.7.2.0/24 dev wg0
Dec 14 16:55:26 vpn-tp7-secu wg-quick[1309]: [#] ip link set mtu 1420 up dev wg0
Dec 14 16:55:26 vpn-tp7-secu wg-quick[1309]: [#] firewall-cmd --zone=public --add-masquerade
Dec 14 16:55:27 vpn-tp7-secu wg-quick[1348]: success
Dec 14 16:55:27 vpn-tp7-secu wg-quick[1309]: [#] firewall-cmd --add-interface=wg0 --zone=public
Dec 14 16:55:27 vpn-tp7-secu wg-quick[1357]: success
Dec 14 16:55:27 vpn-tp7-secu systemd[1]: Finished WireGuard via wg-quick(8) for wg0.
```

🌞 **Client Wireguard sur `martine.tp7.secu`**

```bash
[gwuill@martinetp7secu wireguard]$ sudo cat ./martine.conf
[Interface]
Address = 10.7.2.11/24
PrivateKey = UC94PbO9M[...]aLVjtZ++h4T128=

[Peer]
PublicKey = /kOPAz5WW0[...]q6VwjILQ/Nv4gE=
AllowedIPs = 0.0.0.0/0
Endpoint = 10.7.1.100:13337

[gwuill@martinetp7secu wireguard]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=55 time=20.5 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=55 time=107 ms
```

🌞 **Client Wireguard sur votre PC**

```
[Interface]
PrivateKey = wKdumCYryyIr540X9h1CZLw/mDnspbNF+nJHoPYIjms=
Address = 10.7.2.100/24

[Peer]
PublicKey = /kOPAz5WW0IQR/dBJyT8ci10x/9KBq6VwjILQ/Nv4gE=
AllowedIPs = 10.7.2.0/24
Endpoint = 10.7.1.100:13337

PS C:\Users\guill> ping 10.7.2.11

Envoi d’une requête 'Ping'  10.7.2.11 avec 32 octets de données :
Réponse de 10.7.2.11 : octets=32 temps=1 ms TTL=63
Réponse de 10.7.2.11 : octets=32 temps=1 ms TTL=63
```

# II. SSH

## 1. Setup

🌞 **Générez des confs Wireguard pour tout le monde**

```
[gwuill@bastiontp7 ~]$ ping 10.7.2.13
64 bytes from 10.7.2.13: icmp_seq=1 ttl=64 time=0.032 ms
[gwuill@bastiontp7 ~]$ ping 10.7.2.11
64 bytes from 10.7.2.11: icmp_seq=5 ttl=63 time=2.86 ms
[gwuill@bastiontp7 ~]$ ping 10.7.2.100
PING 10.7.2.100 (10.7.2.100) 56(84) bytes of data.
64 bytes from 10.7.2.100: icmp_seq=1 ttl=127 time=1.72 ms
```

## 2. Connexion par clé

🌞 **Générez une nouvelle paire de clés pour ce TP**

```
PS C:\Users\guill> type C:\Users\guill\.ssh\id_ed25519.pub | ssh gwuill@10.7.2.0 "cat >> .ssh/authorized_keys"
gwuill@10.7.2.0's password:
PS C:\Users\guill> ssh gwuill@10.7.2.0
Enter passphrase for key 'C:\Users\guill/.ssh/id_ed25519':
Last login: Sun Dec 17 20:04:09 2023 from 10.7.2.100
[gwuill@vpn-tp7-secu ~]$ exit
logout
Connection to 10.7.2.0 closed.
```
PS : c'est l'enfer sur Windows... (comme d'hab)

## 3. Conf serveur SSH

🌞 **Changez l'adresse IP d'écoute**

```
[gwuill@vpn-tp7-secu ~]$ sudo cat /etc/ssh/sshd_config
ListenAddress 10.7.2.0
```
```
[gwuill@webtp7 ~]$ sudo cat /etc/ssh/sshd_config
ListenAddress 10.7.2.13
```
```
[gwuill@bastiontp7 ~]$ sudo cat /etc/ssh/sshd_config
ListenAddress 10.7.2.12
```
```
[gwuill@martinetp7 ~]$ sudo cat /etc/ssh/sshd_config
ListenAddress 10.7.2.11
```

🌞 **Améliorer le niveau de sécurité du serveur**

- sur toutes les machines
- mettre en oeuvre au moins 3 configurations additionnelles pour améliorer le niveau de sécurité
- 3 lignes (au moins) à changer quoi
- le doc est vieux, mais en dehors des recommendations pour le chiffrement le reste reste très cool : [l'ANSSI avait édité des recommendations pour une conf OpenSSH](https://cyber.gouv.fr/publications/openssh-secure-use-recommendations)

# III. HTTP

## 1. Initial setup

🌞 **Monter un bête serveur HTTP sur `web.tp7.secu`**

```nginx
server {
    server_name web.tp7.secu;

    listen 10.7.2.13:80;

    # vous collez un ptit index.html dans ce dossier et zou !
    root /var/www/site_nul/;
}
```

🌞 **Site web joignable qu'au sein du réseau VPN**

```
[gwuill@webtp7 ~]$ sudo firewall-cmd --list-all --zone=drop
drop (active)
  target: DROP
  icmp-block-inversion: no
  interfaces: web
  sources: 10.7.2.1/24
  services: http
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```
```
PS C:\Users\guill> curl 10.7.1.13
curl : Impossible de se connecter au serveur distant
```

🌞 **Accéder au site web**

```
PS C:\Users\guill> curl 10.7.2.13
Content           : <h1> Site nul </h1>
```

## 2. Génération de certificat et HTTPS

### A. Préparation de la CA


🌞 **Générer une clé et un certificat de CA**

```bash
[gwuill@webtp7 ~]$ ls
CA.key  CA.pem
```

### B. Génération du certificat pour le serveur web

🌞 **Générer une clé et une demande de signature de certificat pour notre serveur web**

```bash
[gwuill@webtp7 ~]$ ls
CA.key  CA.pem  web.tp7.secu.csr  web.tp7.secu.key
```

🌞 **Faire signer notre certificat par la clé de la CA**

```
[gwuill@webtp7 ~]$ ls
CA.key  CA.pem  CA.srl  v3.ext  web.tp7.secu.crt  web.tp7.secu.csr  web.tp7.secu.key
```

### C. Bonnes pratiques RedHat

🌞 **Déplacer les clés et les certificats dans l'emplacement réservé**

```
[gwuill@webtp7 ~]$ sudo ls -al /etc/pki/tls/private/
total 20
drw-r--r--. 2 root   root     96 Dec 17 16:43 .
drwxr-xr-x. 5 root   root    126 Oct 12 13:26 ..
-rw-------. 1 gwuill gwuill 3422 Dec 17 16:38 CA.key
-rw-r--r--. 1 gwuill gwuill 2041 Dec 17 16:39 CA.pem
-rw-r--r--. 1 gwuill gwuill   41 Dec 17 16:42 CA.srl
-rw-r--r--. 1 gwuill gwuill 1732 Dec 17 16:41 web.tp7.secu.csr
-rw-------. 1 gwuill gwuill 3268 Dec 17 16:40 web.tp7.secu.key

[gwuill@webtp7 ~]$ sudo ls -al /etc/pki/tls/certs/
-rw-r--r--. 1 gwuill gwuill 2106 Dec 17 16:42 web.tp7.secu.crt

```

### D. Config serveur Web

🌞 **Ajustez la configuration NGINX**

```nginx
server {
    server_name web.tp7.secu;

    listen 10.7.2.13:443 ssl;

    ssl_certificate /etc/pki/tls/certs/web.tp7.secu.crt;
    ssl_certificate_key /etc/pki/tls/private/web.tp7.secu.key;

    root /var/www/site_nul/;
}
```

🌞 **Prouvez avec un `curl` que vous accédez au site web**

- depuis votre PC
- avec un `curl -k` car il ne reconnaît pas le certificat là

🌞 **Ajouter le certificat de la CA dans votre navigateur**

- vous pourrez ensuite visitez `https://web.tp7.b2` sans alerte de sécurité, et avec un cadenas vert
- il faut aussi ajouter l'IP de la machine à votre fichier `hosts` pour qu'elle corresponde au nom `web.tp7.b2`

> *En entreprise, c'est comme ça qu'on fait pour qu'un certificat de CA non-public soit trusted par tout le monde : on dépose le certificat de CA dans le navigateur (et l'OS) de tous les PCs. Evidemment, on utilise une technique de déploiement automatisé aussi dans la vraie vie, on l'ajoute pas à la main partout hehe.*
