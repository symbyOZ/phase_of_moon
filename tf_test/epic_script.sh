#!/bin/bash

#function docker_install () {
  #statements
sudo apt-get update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
#}
#function nginx_run () {
  #statements
sudo docker run -d -p 80:80 nginx
#}

#docker_install
#nginx_run
