# I. Init

## 3. sudo c pa bo


🌞 **Ajouter votre utilisateur au groupe `docker`**

```
[gwuill@docker ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## 4. Un premier conteneur en vif

> *Je rappelle qu'un "conteneur" c'est juste un mot fashion pour dire qu'on lance un processus un peu isolé sur la machine.*

Bon trève de blabla, on va lancer un truc qui juste marche.

On va lancer un conteneur NGINX qui juste fonctionne, puis custom un peu sa conf. Ce serait par exemple pour tester une conf NGINX, ou faire tourner un serveur NGINX de production.

> *Hé les dévs, **jouez le jeu bordel**. NGINX c'est pas votre pote OK, mais on s'en fout, c'est une app comme toutes les autres, comme ta chatroom ou ta calculette. Ou Netflix ou LoL ou Spotify ou un malware. NGINX il est réputé et standard, c'est juste un outil d'étude pour nous là. Faut bien que je vous fasse lancer un truc. C'est du HTTP, c'est full standard, vous le connaissez, et c'est facile à tester/consommer : avec un navigateur.*

🌞 **Lancer un conteneur NGINX**

- avec la commande suivante :

```bash
docker run -d -p 9999:80 nginx
```

> Si tu mets pas le `-d` tu vas perdre la main dans ton terminal, et tu auras les logs du conteneur directement dans le terminal. `-d` comme *daemon* : pour lancer en tâche de fond. Essaie pour voir !

🌞 **Visitons**

```
[gwuill@docker ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS
 NAMES
6efc77479678   nginx     "/docker-entrypoint.…"   5 seconds ago   Up 3 seconds   0.0.0.0:9999->80/tcp, :::9999->80/tcp   funny_murdock
[gwuill@docker ~]$ docker logs 6e
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
[...]
2023/12/21 14:24:01 [notice] 1#1: start worker process 29
[gwuill@docker ~]$ docker inspect 6e
[
    {
        "Id": "6efc77479678a500e19401dc1cfd2a5493890d8f53c96d94713afaecfc49e58c",
        [...]
    }
]
[gwuill@docker ~]$ sudo ss -lnpt
State    Recv-Q    Send-Q       Local Address:Port       Peer Address:Port   Process
LISTEN   0         4096               0.0.0.0:9999            0.0.0.0:*       users:(("docker-proxy",pid=13995,fd=4))
[gwuill@docker ~]$ sudo firewall-cmd --add-port=9999/tcp --permanent
success
[gwuill@docker ~]$ sudo firewall-cmd --reload
success
PS C:\Users\guill> curl http://192.168.56.17:9999
<!DOCTYPE html>
  <html>
      <head>
          <title>Welcome to nginx!</title>
            <style>
            html { color-scheme: light dark; }
            body { width: 35em; margin: 0 auto;
            ont-family: Tahoma, Verdana, Arial, sans-serif; }
            </style...
```
w
🌞 **On va ajouter un site Web au conteneur NGINX**

```
[gwuill@docker nginx]$ ls
index.html  site_nul.conf
```

🌞 **Visitons**

```
[gwuill@docker nginx]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS
             NAMES
db30d97581e3   nginx     "/docker-entrypoint.…"   8 seconds ago   Up 6 seconds   80/tcp, 0.0.0.0:9999->8080/tcp, :::9999->8080/tcp   angry_ride
```
```
PS C:\Users\guill> curl http://192.168.56.17:9999
<h1>MEOOOW</h1>
```

## 5. Un deuxième conteneur en vif

Cette fois on va lancer un conteneur Python, comme si on voulait tester une nouvelle lib Python par exemple. Mais sans installer ni Python ni la lib sur notre machine.

On va donc le lancer de façon interactive : on lance le conteneur, et on pop tout de suite un shell dedans pour faire joujou.

🌞 **Lance un conteneur Python, avec un shell**

```
[gwuill@docker ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS
             NAMES
907c2ac82de9   python    "bash"                   3 minutes ago   Up 3 minutes
             relaxed_chatelet
```

🌞 **Installe des libs Python**

```
root@907c2ac82de9:/# python
Python 3.12.1 (main, Dec 19 2023, 20:14:15) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import aiohttp
```