#!/bin/bash
docker build -t vynu/sample-node-net .
docker push vynu/sample-node-net

ssh vynu@aws.fedora << EOF
docker pull vynu/sample-node-net:latest
docker stop web || true
docker rm web || true
docker rmi vynu/sample-node-net:current || true
docker tag vynu/sample-node-net:latest vynu/sample-node-net:current
docker run -d --net app --restart always --name web -p 3000:3000 vynu/sample-node-net:current
EOF
