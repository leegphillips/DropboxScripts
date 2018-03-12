#!/usr/bin/env bash
echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
apt-get update
apt -y install -t jessie-backports openjdk-8-jre-headless ca-certificates-java
apt-get -y install openjdk-8-jdk curl maven git-core
update-java-alternatives --set java-1.8.0-openjdk-amd64
