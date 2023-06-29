FROM node:20-alpine

# Variables d'environnement
## Globales
ENV app_name hello_nest
## Connextion Postgresql
ENV PGDATABASE dbo
ENV PGUSER cash

WORKDIR /usr/src/app

# Installation de NESTJS
RUN ["npm", "i", "-g", "@nestjs/cli"]

# Création de l'application
RUN nest new $app_name --package-manager npm

EXPOSE 3000

# Démarrage de l'app
WORKDIR $app_name
ENTRYPOINT ["npm", "run", "start"]