# III. Docker compose

Pour la fin de ce TP on va manipuler un peu `docker compose`.

🌞 **Créez un fichier `docker-compose.yml`**

```
[gwuill@docker compose_test]$ cat docker-compose.yml
version: "3"

services:
  conteneur_nul:
    image: debian
    entrypoint: sleep 9999
  conteneur_flopesque:
    image: debian
    entrypoint: sleep 9999
```

🌞 **Lancez les deux conteneurs** avec `docker compose`

```
[gwuill@docker compose_test]$ docker compose up -d
[+] Running 3/3
 ✔ conteneur_flopesque 1 layers [⣿]      0B/0B      Pulled                                                         8.1s
   ✔ bc0734b949dc Already exists                                                                                   0.0s
 ✔ conteneur_nul Pulled                                                                                            8.6s
[+] Running 3/3
 ✔ Network compose_test_default                  Created                                                           1.0s
 ✔ Container compose_test-conteneur_flopesque-1  Started                                                           0.2s
 ✔ Container compose_test-conteneur_nul-1        Started
```

🌞 **Vérifier que les deux conteneurs tournent**

```
[gwuill@docker compose_test]$ docker compose ps
NAME                                 IMAGE     COMMAND        SERVICE               CREATED          STATUS          PORTS
compose_test-conteneur_flopesque-1   debian    "sleep 9999"   conteneur_flopesque   26 seconds ago   Up 24 seconds
compose_test-conteneur_nul-1         debian    "sleep 9999"   conteneur_nul         26 seconds ago   Up 24 seconds
```

🌞 **Pop un shell dans le conteneur `conteneur_nul`**

```
[gwuill@docker compose_test]$ docker exec -it compose_test-conteneur_nul-1 bash
root@bd25d340c125:/# ping conteneur_flopesque
PING conteneur_flopesque (172.18.0.2) 56(84) bytes of data.
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.2): icmp_seq=1 ttl=64 time=0.277 ms
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.2): icmp_seq=2 ttl=64 time=0.169 ms
```

![In the future](./img/in_the_future.jpg)
