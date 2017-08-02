# our nodes are up and running
docker -H :4000 info

# we can now run containers across our nodes as normal
docker -H :4000 run -d --name hello1 dockercloud/hello-world
docker -H :4000 run -d --name hello2 dockercloud/hello-world
docker -H :4000 run -d --name hello3 dockercloud/hello-world
docker -H :4000 run -d --name hello4 dockercloud/hello-world

# if they want to communicate with each other, it gets tricky
# they'd have to expose a port and the ip address that they're running on
# docker networking allows us to create an overlay network that spans all of our machines

# let's create an overlay network called "apps"
docker -H :4000 network create --driver overlay --internal --subnet=10.0.9.0/24 apps

# now we can run
docker -H :4000 run -d --net apps --name hello5 dockercloud/hello-world
docker -H :4000 run -d --net apps --name hello6 dockercloud/hello-world

# if we open a terminal in hello5, we can ping hello6 successfully by hostname
docker -H exec -it hello5 /bin/sh
ping hello6
# you'll notice the internal ip address is referenced
# we don't even have to expose a port, it's 100% internal networking

# we could also use wget to make a request to it's webserver, which is running on port 80
wget -O - hello6

# because we're in an isolated network, we can't access hello1-4
wget -O - hello4 #doesn't work

