# Docker

le fichier `docker-compose.yml` va créer 3 conteneurs :
- `application` éxecutant ruby en version 1.9.3-p551 et avec bundler pour la gestion des dépendances.  
   (Redmine en version 2.0.3 est monté dans le répertoire /redmine du conteneur)
- `database` éxecutant mysql en version 5.5
- `phpmyadmin`


## Pré-requis

- Installer docker https://docs.docker.com/engine/installation/
- Installer docker-compose https://docs.docker.com/compose/install/


## Préparation des images

Copier `docker-compose.yml.dist` vers `docker-compose.yml` et adapter les ports si nécessaire.
(si le port 3000 est déjà utilisé sur votre machine remplacer `- 3000:3000` par `- 3001:3000`)

Lancer les conteneurs avec la commande
```bash
docker-compose up
```
Si vous n'avez pas changé les ports mapping dans docker-compose.yml :
- Redmine est disponible par défaut à l'adresse http://localhost:3000
- PHPMyAdmin est disponible par défaut à l'adresse http://localhost:8080
sauf si vous avez changé le port mapping dans docker-compose.yml


## Préparation de Redmine

Au lancement du conteneur redmine_application le script ./docker/redmine/entry-point.sh est éxecuté.

```bash
# Installer les dépendances (gems) de Redmine avec bundler
# les dépendances seront téléchargées dans `/usr/local/bundle` qui est un volume monté à partir de `./docker/ruby/bundle`
bundle install
# Créer la base de données de Redmine
rake db:create
# Créer les tables et données nécessaires à Redmine
rake db:migrate
# Génerer le jeton secret utilisé par Rails pour encoder les cookies de session
rake generate_secret_token
# Lancer le serveur WEBRick
rails s
```


## Divers

Stop et supprime tous les containers
```bash
docker-compose down
```

Entrer en bash sur le conteneur application :
```bash
docker exec -it redmine_application bash
```

Détruire la base de données :
```bash
docker-compose exec redmine_application rake db:drop
```

Créer la base de données :
```bash
docker-compose exec redmine_application rake db:create
```

Créer les tables de redmine :
```bash
docker-compose exec redmine_application rake db:migrate
```

## Note
L'image redmine hérite de l'image fleporcq/ruby:1.9.3.
Si vous souhaitez recontruire l'image fleporcq/ruby:1.9.3,  
vous pouvez la build :

```bash
docker build -t [tag] ./docker/ruby
```
