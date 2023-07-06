# syntax=docker/dockerfile:1

## Image's base
FROM node:20-alpine as base
WORKDIR /usr/src/app
# NESTJS install via npm
RUN npm i -g @nestjs/cli
# Creating the application
RUN nest new hello_nestjs --package-manager npm
RUN pwd
RUN ls -l

## Targer for E2E test unit
FROM base as test
WORKDIR /usr/src/app/hello_nestjs
# Tests units
RUN npm i --save-dev @nestjs/testing
RUN npm test

## Targer for Runing in production
FROM base as production
# Enter to the new application folder ans start the app
WORKDIR /usr/src/app/hello_nestjs
ENTRYPOINT npm run start
EXPOSE 3000