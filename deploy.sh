#!/bin/bash
docker build -t almandsky/sample-node .
docker push almandsky/sample-node

ssh deploy@159.203.228.196 << EOF
docker pull almandsky/sample-node:latest
docker stop web || true
docker rm web || true
docker rmi almandsky/sample-node:current || true
docker tag almandsky/sample-node:latest almandsky/sample-node:current
docker run -d --net app --restart always --name web -p 3000:3000 almandsky/sample-node:current
EOF
