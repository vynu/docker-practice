#create 6 docker nodes

# ssh into manager0
ssh root@<manager0-ip>
# create a consul backend for swarm
docker run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap
# to go a step further and create a high-availability consul cluster
# see here https://hub.docker.com/r/progrium/consul/

docker run -d -p 4000:4000 --name swarm-manager swarm manage -H :4000 --replication --advertise <manager0-ip>:4000 consul://<manager0-ip>:8500

# ssh into manager1
docker run -d -p 4000:4000 --name swarm-manager swarm manage -H :4000 --replication --advertise <manager1-ip>:4000 consul://<manager0-ip>:8500

# ssh into nodes
ssh root@<node-ip> docker run -d --name swarm --restart always swarm join --advertise=<node-ip>:2375 consul://<manager0-ip>:8500

#ssh into master node
docker -H :4000 info

# every node is pending...this is because 2375 isn't exposed yet
# verify that tcp socket is open on all application nodes
vim /etc/default/docker
# add DOCKER_OPTS="--cluster-advertise eth1:2376 --cluster-store consul://<manager0-ip>:8500 -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"
# very important to lock down security here!!!!
restart docker

docker -H :4000 info
docker -H :4000 ps
