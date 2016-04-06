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

Récupérer les trois images depuis docker-hub (mysql:5.5,phpmyadmin/phpmyadmin,fleporcq/ruby:1.9.3)
```bash
docker-compose pull
```
Si vous souhaitez ne pas puller l'image fleporcq/ruby:1.9.3,  
vous pouvez la build :

```bash
docker-compose build
```

## Préparation de Redmine

Entrer en bash dans le conteneur application(construit à partir de l'image Ruby)
Le répertoire courant est `/redmine` qui est un volume monté à partir de `.`

```bash
docker-compose run --rm application bash
```

Une fois dans le bash du conteneur application :

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
# Une fois ces commandes passées dans le bash du conteneur, vous pouvez quitter
exit
```

## Lancement du serveur de développement WEBRick

```bash
docker-compose run --rm --service-ports application rails s
```

Si vous n'avez pas changé les ports mapping dans docker-compose.yml :
- Redmine est disponible par défaut à l'adresse http://localhost:3000 (sauf )
- PHPMyAdmin est disponible par défaut à l'adresse http://localhost:8080 (sauf si vous avez changé le port mapping dans docker-compose.yml)

## Divers

Stop et supprime tous les containers
```bash
docker-compose down
```

Détruire la base de données :
```bash
docker-compose run --rm application rake:db:drop
```

## Windows
```bash
docker run --rm -it -v /:/redmine fleporcq/ruby:1.9.3 //bin/bash
bundle install
rake db:create
rake db:migrate
rake generate_secret_token
exit
docker-compose up
```
