#!/bin/bash
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
