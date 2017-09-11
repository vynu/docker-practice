#!/bin/bash
docker build -t vynu/test-db-migrations .
docker push vynu/test-db-migrations

ssh vynu@aws.fedora << EOF
docker pull vynu/test-db-migrations
docker run --net app --rm vynu/test-db-migrations
docker rmi vynu/sample-node
EOF
