#!/bin/bash
db_name=$1
if [ -z "$1" ]; then
  db_name="production"
fi
db_host=$2
if [ -z "$2" ]; then
  db_host='mysql'
fi
db_user=$3
if [ -z "$3" ]; then
  db_user='production'
fi
db_pw=$4
if [ -z "$4" ]; then
  db_pw='production'
fi

docker push almandsky/sample-node

ssh deploy@159.203.228.196 << EOF
docker pull almandsky/sample-node:latest
docker stop web || true
docker rm web || true
docker rmi almandsky/sample-node:current || true
docker tag almandsky/sample-node:latest almandsky/sample-node:current
docker run -d --net app --restart always --name web -p 3000:3000 -e DB_NAME=$db_name -e DB_HOST=$db_host -e DB_USER=$db_user -e DB_PASSWORD=$db_pw almandsky/sample-node:current
EOF