# ssh into master node
docker -H :4000 info
# you can see any existing labels on nodes

# To add new/custom labels
# ssh into app node
vim /etc/default/docker
# add --label type=apps --label environment=production to DOCKER_OPTS

# ssh back into master node
docker -H :4000 run \
  -e constraint:type==apps \
  -e constraint:environment=production \
  --name hell01 \
  dockercloud/hello-world

docker -H :4000 run \
  -e constraint:type==apps \
  -e constraint:environment=staging \
  --name hell02 \
  dockercloud/hello-world
