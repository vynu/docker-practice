#!/bin/bash
docker build -t vynu/sample-node-old .
docker push vynu/sample-node-old

ssh vynu@aws.fedora << EOF
docker pull vynu/sample-node-old:latest
docker stop web || true
docker rm web || true
docker rmi vynu/sample-node-old:current || true
docker tag vynu/sample-node-old:latest vynu/sample-node-old:current
docker run -d --restart always --name web -p 3000:3000 vynu/sample-node-old:current
EOF
