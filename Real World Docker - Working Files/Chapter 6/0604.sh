# standard vulnerabilities exist
# standard vulnerabilities
#  - root user login should have without-password
#  - ideally, port 22 is restricted to a whitelist of ip addresses
#  - rate limiting on port 22

# docker vulnerabilities exist
# swarm manager is publicly accessible
docker -H <manager-ip>:4000 info
# docker daemon is publicly accessible
docker -H <swarm-node-ip>:2375 ps
# consul is publicly accessible
curl <manager-ip>:8500


# on swarm nodes
apt-get install -y iptables-persistent
# accept 2375 from swarm managers
iptables -A INPUT -p tcp -s <manager0-ip> --dport 2375 -j ACCEPT
iptables -A INPUT -p tcp -s <manager1-ip> --dport 2375 -j ACCEPT
# drop everything else
iptables -A INPUT -p tcp --dport 2375 -j DROP
invoke-rc.d iptables-persistent save


# on swarm masters
apt-get install -y iptables-persistent
# make a new security group
iptables -N DOCKER-SECURITY
# put this group before docker access
iptables -I FORWARD -o docker0 -j DOCKER-SECURITY
# accept port 4000 from this node
iptables -A DOCKER-SECURITY -p tcp -s 127.0.0.1 --dport 4000 -j ACCEPT
# iptables -D DOCKER-SECURITY -i eth1 -p tcp --dport 8500 -m state --state NEW,ESTABLISHED -j ACCEPT
# accept unprivileged traffic from known sources eth0 ip addresses
iptables -A DOCKER-SECURITY -p tcp -s <lb0-external-ip> --dport 1025:65535 -j ACCEPT
iptables -A DOCKER-SECURITY -p tcp -s <lb1-external-ip> --dport 1025:65535 -j ACCEPT
iptables -A DOCKER-SECURITY -p tcp -s <app0-external-ip> --dport 1025:65535 -j ACCEPT
iptables -A DOCKER-SECURITY -p tcp -s <app1-external-ip> --dport 1025:65535 -j ACCEPT
# accept unprivileged traffic from known sources eth1 ip addresses
iptables -A DOCKER-SECURITY -p tcp -s <lb0-internal-ip> --dport 1025:65535 -j ACCEPT
iptables -A DOCKER-SECURITY -p tcp -s <lb1-internal-ip> --dport 1025:65535 -j ACCEPT
iptables -A DOCKER-SECURITY -p tcp -s <app0-internal-ip> --dport 1025:65535 -j ACCEPT
iptables -A DOCKER-SECURITY -p tcp -s <app1-internal-ip> --dport 1025:65535 -j ACCEPT
# Drop connections on all other sources
iptables -A DOCKER-SECURITY -p tcp --dport 1025:65535 -j DROP
invoke-rc.d iptables-persistent save

# DO YOU STILL NEED TO ACCESS THE DAEMON PUBLICLY/SECURELY?
# You can install enable TLS with these instructions
# https://docs.docker.com/engine/security/https/
