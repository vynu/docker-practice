#!/bin/bash
docker build -t vynu/test-db-migrations .
docker push vynu/test-db-migrations

ssh deploy@docker.digocn << EOF
docker pull vynu/test-db-migrations
docker run --net app --rm vynu/test-db-migrations
docker rmi vynu/sample-node
EOF
