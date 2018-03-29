#!/usr/bin/env bash

#enable output
set -x

#set UK timezone
mv /etc/localtime /etc/localtime.default
cp /usr/share/zoneinfo/Europe/London /etc/localtime
