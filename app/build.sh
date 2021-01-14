#!/usr/bin/env bash

docker stop blender-web
docker stop blender-app
docker rm blender-web
docker rm blender-app
docker network rm blender-net
docker volume rm blender-data

docker build -t blender --network=host .
docker network create blender-net
docker volume create blender-data

docker run --detach --restart=always --volume=blender-data:/data --net=blender-net --name=blender-app blender

cd caddy
docker build -t blender-caddy --network=host .
APP_PASSWORD_HASH=$(docker run --rm -it blender-caddy caddy hash-password -plaintext 'password')

docker run --detach --restart=always --volume=blender-data:/data --net=blender-net --name=blender-web --env=APP_USERNAME="user" --env=APP_PASSWORD_HASH="${APP_PASSWORD_HASH}" --publish=4040:4040 blender-caddy
