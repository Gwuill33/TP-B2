# TP2 Commun : Stack PHP

🌞 **`docker-compose.yml`**

- genre `tp2/php/docker-compose.yml` dans votre dépôt git de rendu
- votre code doit être à côté dans un dossier `src` : `tp2/php/src/tous_tes_bails.php`
- s'il y a un script SQL qui est injecté dans la base à son démarrage, il doit être dans `tp2/php/sql/seed.sql`
  - on appelle ça "seed" une database quand on injecte le schéma de base et éventuellement des données de test
- bah juste voilà ça doit fonctionner : je git clone ton truc, je `docker compose up` et ça doit fonctionne :)
- ce serait cool que l'app affiche un truc genre `App is ready on http://localhost:80` truc du genre dans les logs !

➜ **Un environnement de dév local propre avec Docker**

- 3 conteneurs, donc environnement éphémère/destructible
- juste un **`docker-compose.yml`** donc facilement transportable
- TRES facile de mettre à jour chacun des composants si besoin
  - oh tiens il faut ajouter une lib !
  - oh tiens il faut une autre version de PHP !
  - tout ça c'est np

![save urself](img/save_urself.png)
