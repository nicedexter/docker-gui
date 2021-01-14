#!/usr/bin/env bash

docker stop jasp-web
docker stop jasp-app
docker rm jasp-web
docker rm jasp-app
docker network rm jasp-net
docker volume rm jasp-data

docker build -t jasp --network=host .
docker network create jasp-net
docker volume create jasp-data

docker run --detach --restart=always --volume=jasp-data:/data --net=jasp-net --name=jasp-app jasp

cd caddy
docker build -t jasp-caddy --network=host .
APP_PASSWORD_HASH=$(docker run --rm -it jasp-caddy caddy hash-password -plaintext 'password')

docker run --detach --restart=always --volume=jasp-data:/data --net=jasp-net --name=jasp-web --env=APP_USERNAME="user" --env=APP_PASSWORD_HASH="${APP_PASSWORD_HASH}" --publish=3030:3030 jasp-caddy
