docker stop gimp-web
docker stop gimp-app
docker rm gimp-web
docker rm gimp-app
docker network rm gimp-net
docker volume rm gimp-data