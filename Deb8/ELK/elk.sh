#!/usr/bin/env bash

#enable output
set -x

#install Java8
echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
apt-get update
apt -y install -t jessie-backports openjdk-8-jre-headless ca-certificates-java
apt-get -y install openjdk-8-jdk curl maven git-core
update-java-alternatives --set java-1.8.0-openjdk-amd64

#install ELK
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
apt-get update && export ES_SKIP_SET_KERNEL_PARAMETERS=true && apt-get -y install kibana elasticsearch
wget -O /etc/elasticsearch/jvm.options https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/elasticsearch-jvm-options
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable kibana.service
systemctl start kibana.service

#install Nginx
systemctl stop apache2.service
apt-get -y install nginx apache2-utils
wget -O /etc/nginx/sites-available/default https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/nginx-default-available
systemctl restart nginx.service
