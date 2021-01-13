#!/usr/bin/env bash

docker stop gimp-web
docker stop gimp-app
docker rm gimp-web
docker rm gimp-app
docker network rm gimp-net
docker volume rm gimp-data

docker build -t gimp .
docker network create gimp-net
docker volume create gimp-data

docker run --detach --restart=always --volume=gimp-data:/data --net=gimp-net --name=gimp-app gimp

cd caddy
docker build -t gimp-caddy .
APP_PASSWORD_HASH=$(docker run --rm -it gimp-caddy caddy hash-password -plaintext 'password')

docker run --detach --restart=always --volume=gimp-data:/data --net=gimp-net --name=gimp-web --env=APP_USERNAME="user" --env=APP_PASSWORD_HASH="${APP_PASSWORD_HASH}" --publish=8080:8080 gimp-caddy
