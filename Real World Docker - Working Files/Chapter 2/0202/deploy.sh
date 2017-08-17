#!/bin/bash
docker build -t vynu/sample-node .
docker push vynu/sample-node

ssh deploy@docker.digocn << EOF
docker pull vynu/sample-node:latest
docker stop web || true
docker rm web || true
docker rmi vynu/sample-node:current || true
docker tag vynu/sample-node:latest vynu/sample-node:current
docker run -d --restart always --name web -p 3000:3000 vynu/sample-node:current
EOF
