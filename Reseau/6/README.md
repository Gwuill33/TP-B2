# TP6 : Un peu de root-me

## Sommaire

- [TP6 : Un peu de root-me](#tp6--un-peu-de-root-me)
  - [Sommaire](#sommaire)
  - [I. DNS Rebinding](#i-dns-rebinding)
  - [II. Netfilter erreurs courantes](#ii-netfilter-erreurs-courantes)
  - [III. ARP Spoofing Ecoute active](#iii-arp-spoofing-ecoute-active)
  - [IV. Bonus : Trafic Global System for Mobile communications](#iv-bonus--trafic-global-system-for-mobile-communications)

## I. DNS Rebinding

> [**Lien vers l'épreuve root-me.**](https://www.root-me.org/fr/Challenges/Reseau/HTTP-DNS-Rebinding)

- utilisez l'app web et comprendre à quoi elle sert
- lire le code ligne par ligne et comprendre chaque ligne
  - en particulier : comment/quand est récupéré la page qu'on demande
- se renseigner sur la technique DNS rebinding

🌞 **Write-up de l'épreuve**

Objectif : accéder à http://challenge01.root-me.org:54022/admin.

Ce qu'on nous fournit :
- Une page web avec un service qui permet de faire des requêtes HTTPS/HTTP qui nous apprends que pour acceder à la page admin, seul l'ip 127.0.0.1 peut y accéder.

- Un code source de l'application web qui nous apprends que pour acceder à la page admin, seul l'ip 127.0.0.1 peut y accéder.qui nous apprends que pour acceder à la page admin, seul l'ip 127.0.0.1 peut y accéder. Mais également qu'il y a une vérif d'ip pas super fiable.

- Une technique de DNS rebinding. Cela consiste à faire une requête DNS qui va retourner une ip différente en fonction du temps. Cela permet de contourner la vérif d'ip.


Grace a ce site https://lock.cmpxchg8b.com/rebinder.html, on peut créer un nom de domaine qui va nous permettre de faire une requête DNS rebinding.
On crée ainsi un nom de domaine pour la résolution des IP suivantes : 127.0.0.1 et 8.8.8.8
Il nous donne alors le nom de domaine suivant : 7f000001.08080808.rbndr.us


Plus qu'a spam un peu le service web avec ce nom de domaine avec sript et on obtient le flag.

🌞 **Proposer une version du code qui n'est pas vulnérable**

Pour empêcher ce petit trick on peut proposer cette solution :

- Utiliser un resolveur DNS configuré pour ne pas résoudre les noms de domaine qui ne sont pas dans la zone DNS du serveur. On peut utiliser celui de Google ou de Cloudflare.

## II. Netfilter erreurs courantes

> [**Lien vers l'épreuve root-me.**](https://www.root-me.org/fr/Challenges/Reseau/Netfilter-erreurs-courantes)

🌞 **Write-up de l'épreuve**

On peut récup la conf du firewall avec l'url suivante : https://challenge01.root-me.org/reseau/ch17/fw.sh

Dedans on peut voir plusieurs régles qui interdit l'accés au port 54017. Cepedant deux lignes nous intéresse :

```sh
# apply some flood protection against remaining trafic
IP46T -A INPUT-HTTP -m limit --limit 3/sec --limit-burst 15 -j LOG --log-prefix 'FW_FLOODER '
IP46T -A INPUT-HTTP -m limit --limit 3/sec --limit-burst 15 -j DROP
```

Ici, ces deux lignes permettent l'anti-flood et le write dans les logs mais en aucun cas le drop. Il suffit donc de spam l'url suivant : http://challenge01.root-me.org:54017/ pour passer outre le firewall. Car en effet des qu'une conditon est remplie, le firewall ne va pas plus loin dans les régles.

Voici la commande a tapper : for i in {1..100}; do curl -s http://challenge01.root-me.org:54017/; done

Et bim on a le flag.


🌞 **Proposer un jeu de règles firewall**

Il faut corriger la ligne qui log. 
Voici une solution :

```sh
iptables -A INPUT-FINAL -m limit --limit 2/sec --limit-burst 2 -j LOG --log-prefix 'FW_INPUT_DROP '
iptables -A INPUT-FINAL -j DROP
```

## III. ARP Spoofing Ecoute active

> [**Lien vers l'épreuve root-me.**](https://www.root-me.org/fr/Challenges/Reseau/ARP-Spoofing-Ecoute-active)

🌞 **Write-up de l'épreuve**

Accés a une machine Debian avec l'ip suivant : 172.18.0.4/16

Petit nmap pour voir ce qu'il y a sur le réseau : nmap -sn 172.18.0.1/24

On obtient alors 3 host up : 172.18.0.1, 172.18.0.2 et 172.18.0.3

On scan alors les ports de ces 3 machines : nmap -sV -p- 172.18.0.1-3

Voici les résultats :

```
172.18.0.1 : 

22 /tcp ssh
22222 /tcp easyengine

172.18.0.2 : 

Rien

172.18.0.3 : 

3306/tcp mysql
```

On voit un service mysql et un server web, on va donc faire un MITM pour récupérer les trames entre ces trois machines.

Voici le petit script bash avec dsniff :

```sh
#!/bin/bash

arpspoof -t 172.18.0.1 172.18.0.2 &
arpspoof -t 172.18.0.2 172.18.0.1 &
arpspoof -t 172.18.0.3 172.18.0.1 &
arpspoof -t 172.18.0.1 172.18.0.3 &
arpspoof -t 172.18.0.3 172.18.0.2 &
arpspoof -t 172.18.0.2 172.18.0.3 &
```

On attend un peu et on récupère les trames avec wireshark et on obtient ce fichier : [Trame](./toto.pcap)

On peut y voir plusieurs trames intéressantes avec notament ce qui semble une communiation entre le client 172.18.0.3 et le server Mysql.

Dedans on y retrouve une partie du flag mais également un mot de passe hashé et un salt.

Avant cela, il faut comprendre ce qu'il se passe entre ces deux machines. Le client est le premier à envoyer une requête au server. Le server va lui envoyer un challenge au client avec un salt. Le client va alors faire des calculs avec le salt et le mot de passe pour obtenir un hash.
Ce hash a être envoyé au server qui va le comparer avec le hash qu'il a calcuté de son côté. Si les deux hash sont identique, alors le client est authentifié. Cette technique permet de ne pas envoyer le mot de passe en clair ou hashé sur le réseau.
Mais si on connait la technique de calcul efféctué par le client, on peut alors retrouver le mot de passe.

Sur ce github, un petit gars avec fait un script python qui répond à notre problème : https://github.com/kazkansouh/odd-hash

On suit le petit tuto et on obtient le flag.

🌞 **Proposer une configuration pour empêcher votre attaque**

Pour empêcher une attaque de ce type, il faut empêcher le MITM. Pour cela, on peut ajouter à la main les adresses MAC associé à chaque IP dans la table ARP. Cela peut être une solution si il y a peu de machine sur le réseau.

On peut le faire avec la commande suivante : arp -s <IP> <MAC>

La version de la base de donnée du server mysql est également importante. En effet mysql propose une version 8.0 avec un nouveau plugin d'authentification par défaut, le caching_sha2_password. Mais si la version de la base de donnée doit être la 5.7, on peut choisir un autre plugin d'authentification.

Et puis tout simplement, changer le mot de passe pour accéder à la base de donnée en root. Il faut utilisé un générateur de mot de passe beaucoup plus complexe que celui utilisé dans l'épreuve.

## IV. Bonus : Trafic Global System for Mobile communications

⭐ **BONUS : Write-up de l'épreuve**

On nous donne un fichier pcap avec dedans à ce qui semble être une communication entre un téléphone et une antenne relais. Le titre du challenge nous donne un indice sur le protocole utilisé : GSM. On est sur la bonne voie.

A premiere vue, on peut voir qu'il y a uen trame plus longue que les autres. On peut donc supposer que c'est ce qui nous interesse. Dedans il y a une partie data avec 72 bytes. 

Si on se référe à la doc du protocole GSM, on peut voir que la string de 72 bytes et composé de 2 parties : 12 bytes pour l'entête et 60 bytes pour le payload.

Avec ce site : https://www.diafaan.com/sms-tutorials/gsm-modem-tutorial/online-sms-pdu-decoder/ et en enlevant les 12 bytes de l'entête, on peut décoder le payload et on obtient le flag.