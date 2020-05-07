#!/bin/bash

#Unistall old version of docker
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
				  
#Setup the repository
yum install -y yum-utils

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
	
#Install docker
yum install -y docker-ce docker-ce-cli containerd.io

#Start and enable docker
systemctl start docker
systemctl enable docker