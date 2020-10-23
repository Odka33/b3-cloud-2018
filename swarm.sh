#!/bin/bash
# it's possible to change variable for match specifics VM

#for i in $(seq 1 5)
for i in $(seq 1 5)
do
	cd /Users/eliebenayoun/Desktop/coreos-vagrant && vagrant ssh core-O$i -c 'sudo git clone https://github.com/It4lik/B3-Cloud-2018.git '	
	#vagrant ssh core-0$i -c 'cd /etc/ && sudo rm -R ceph'
	#vagrant ssh core-0$i -c 'cd /var/lib/ && sudo rm -R ceph'
	#vagrant ssh core-0$i -c 'cd / && sudo mkdir -p /etc/ceph'
	#vagrant ssh core-0$i -c 'cd /etc/ceph && sudo git clone https://github.com/Odka33/Docker-Provision.git .'
	#vagrant ssh core-0$i -c 'cd /etc/ceph && sudo rm README.md'
	#vagrant ssh core-0$i -c 'docker info'
	#vagrant ssh core-0$i -c 'cd B3-Cloud-2018/tp1/app && docker-compose build'
	#vagrant ssh core-0$i -c 'cd / && sudo chmod +x /opt/bin/docker-compose'
	#vagrant ssh core-0$i -c 'cd / && sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /opt/bin/docker-compose'
done



