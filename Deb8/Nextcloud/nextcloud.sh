#!/usr/bin/env bash

#enable output
set -x

#set UK timezone
mv /etc/localtime /etc/localtime.default
cp /usr/share/zoneinfo/Europe/London /etc/localtime

apt-get update -y
apt-get upgrade -y

echo 'deb http://apt.jurisic.org/debian/ jessie main contrib non-free' >> /etc/apt/sources.list.d/nextcloud.list
wget -q http://apt.jurisic.org/Release.key -O- | apt-key add -
apt-get update

apt-get install postgresql -y

