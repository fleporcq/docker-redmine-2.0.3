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

Construire l'image docker ruby à partir du Dockerfile contenu dans ./docker/ruby et télécharger les image mysql et phpmyadmin depuis docker-hub :

```bash
docker-compose build
```

## Préparation de Redmine

Entrer en bash dans le conteneur application(construit à partir de l'image Ruby)
Le répertoire courant est `/redmine` qui est un volume monté à partir de `.`

```bash
docker-compose run application bash
```

Une fois dans le bash du conteneur application :

- Installer les dépendances (gems) de Redmine avec bundler :
```bash
bundle install
```
les dépendances seront téléchargées dans `/usr/local/bundle` qui est un volume monté à partir de `./docker/ruby/bundle`

- Créer la base de données de Redmine
```bash
rake db:create
```
- Créer les tables et données nécessaires à Redmine
```bash
rake db:migrate
```
- Génerer le jeton secret utilisé par Rails pour encoder les cookies de session
```bash
rake generate_secret_token
```

- Une fois ces commandes passées dans le bash du conteneur, vous pouvez quitter
```bash
exit
```

## Lancement du serveur de développement WEBRick

```bash
docker-compose run --service-ports application rails s
```

Si vous n'avez pas changé les ports mapping dans docker-compose.yml :
- Redmine est disponible par défaut à l'adresse http://localhost:3000 (sauf )
- PHPMyAdmin est disponible par défaut à l'adresse http://localhost:8080 (sauf si vous avez changé le port mapping dans docker-compose.yml)

## Divers

Détruire les conteneurs :
```bash
docker-compose down
```

Détruire la base de données :
```bash
docker-compose run application rake:db:drop
```
