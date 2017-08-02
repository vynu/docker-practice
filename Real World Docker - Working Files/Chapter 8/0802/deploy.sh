#!/bin/bash
docker build -t willrstern/test-node .
docker push willrstern/test-node

ssh root@162.243.27.75 << 'EOF'
  for i in `seq 1 3`
  do
    docker -H :4000 build --build-arg="affinity:container==~web$i" --pull - <<< "FROM willrstern/test-node"
    docker -H :4000 run -d -e affinity:container==~web$i --restart always --net apps --name web$i-new \
      -e constraint:type==apps \
      -e SERVICE_VIRTUAL_HOST=test.com \
      -e SERVICE_NAME=web \
      -e SERVICE_TAGS=nginx:production \
      -e SERVICE_PORT=3000 \
      willrstern/test-node
  done

  for i in `seq 1 3`
  do
    docker -H :4000 stop web$i || true
    docker -H :4000 rm web$i || true
    docker -H :4000 rename web$i-new web$i
  done
EOF
