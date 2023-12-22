# II. Images

## 1. Images publiques

🌞 **Récupérez des images**

```
[gwuill@docker ~]$ docker image list
REPOSITORY           TAG       IMAGE ID       CREATED        SIZE
linuxserver/wikijs   latest    869729f6d3c5   6 days ago     441MB
mysql                5.7       5107333e08a8   9 days ago     501MB
wordpress            latest    fd2f5a0c6fba   2 weeks ago    739MB
python               3.11      22140cbb3b0c   2 weeks ago    1.01GB
```


🌞 **Lancez un conteneur à partir de l'image Python**

```
root@904b9dafed11:/# python --version
Python 3.11.7
```
## 2. Construire une image


🌞 **Ecrire un Dockerfile pour une image qui héberge une application Python**

```dockerfile
FROM debian

RUN apt update && apt install -y python3 && apt install -y python3-emoji

COPY app.py /app.py

ENTRYPOINT ["/usr/bin/python3", "/app.py"]
```

🌞 **Build l'image**

```
[gwuill@docker python_appp_build]$ docker images
REPOSITORY           TAG              IMAGE ID       CREATED              SIZE
python_app           version_de_ouf   d701a154bd84   About a minute ago   527MB
```


🌞 **Lancer l'image**

```bash
[gwuill@docker python_appp_build]$ docker run python_app:version_de_ouf
Cet exemple d'application est vraiment naze 👎
```
