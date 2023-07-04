FROM node:20-alpine

# Environment variables
## Globales
ENV app_name hello_nestjs

WORKDIR /usr/src/app

# NESTJS install via npm
RUN ["npm", "i", "-g", "@nestjs/cli"]

# Creating the application
RUN nest new $app_name --package-manager npm

EXPOSE 3000

# Enter to the new application folder ans start the app
WORKDIR $app_name
ENTRYPOINT ["npm", "run", "start"]