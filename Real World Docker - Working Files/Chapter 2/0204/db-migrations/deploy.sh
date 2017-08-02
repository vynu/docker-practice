#!/bin/bash
docker build -t willrstern/test-db-migrations .
docker push willrstern/test-db-migrations

ssh deploy@159.203.127.59 << EOF
docker pull willrstern/test-db-migrations
docker run --net web --rm willrstern/test-db-migrations
docker rmi willrstern/sample-node
EOF
