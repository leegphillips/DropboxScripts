#!/usr/bin/env bash

#enable output
set -x

#set UK timezone
mv /etc/localtime /etc/localtime.default
cp /usr/share/zoneinfo/Europe/London /etc/localtime

#install Java8
echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
apt-get update
apt -y install -t jessie-backports openjdk-8-jre-headless ca-certificates-java
apt-get -y install openjdk-8-jdk curl maven git-core netcat
update-java-alternatives --set java-1.8.0-openjdk-amd64

#install ELK
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
apt-get update && export ES_SKIP_SET_KERNEL_PARAMETERS=true && apt-get -y install kibana elasticsearch logstash filebeat
wget -O /etc/elasticsearch/jvm.options https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/elasticsearch-jvm-options
wget -O /etc/logstash/jvm.options https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/logstash-jvm-options
wget -O /etc/logstash/logstash.yml https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/logstash.yml
wget -O /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/filebeat.yml
wget -O /etc/logstash/conf.d/01-http-input.conf https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/conf.d/01-http-input.conf
wget -O /etc/logstash/conf.d/02-beats-input.conf https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/conf.d/02-beats-input.conf
wget -O /etc/logstash/conf.d/12-nginx-log.conf https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/conf.d/12-nginx-log.conf
wget -O /etc/logstash/conf.d/30-elasticsearch-output.conf https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/conf.d/30-elasticsearch-output.conf

wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
tar -xvzf GeoLite2-City.tar.gz
mv GeoLite2-City_20180306/GeoLite2-City.mmdb /etc/logstash

systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable kibana.service
systemctl start kibana.service
systemctl enable logstash.service
systemctl start logstash.service

#install Nginx filebeat connector
cd /usr/share/elasticsearch/
bin/elasticsearch-plugin install -s --batch ingest-geoip
bin/elasticsearch-plugin install -s --batch ingest-user-agent
filebeat modules enable nginx
filebeat setup
systemctl enable filebeat.service
systemctl start filebeat.service

#install Nginx
systemctl stop apache2.service
apt-get -y install nginx apache2-utils
wget -O /etc/nginx/sites-available/default https://raw.githubusercontent.com/leegphillips/Scripts/master/Deb8/ELK/nginx-default-available
systemctl restart nginx.service

#add dummy data directly into ElasticSearch
curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" "http://localhost:9200/direct-elasticsearch/test/1" -d "{ \"field\" : \"value\"}"
curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" "http://localhost:9200/direct-elasticsearch/test/2" -d "{ \"field\" : \"value\"}"

#add dummy data into ElasticSearch via LogStash via HTTP connector
curl -v -XPUT 'http://localhost:31311/twitter/tweet/1' -d 'hello'
curl -v -XPUT 'http://localhost:31311/twitter/tweet/2' -d 'hello2'
