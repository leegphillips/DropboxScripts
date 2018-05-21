#!/bin/bash

du -a --time $1 | sha256sum > monitor
while true ; do
  du -a --time $1 | sha256sum > current
  if [ "$(< monitor)" != "$(< current)" ]
  then
    mv current monitor
    tar -zcf "$1.tar.gz" $1
    gpg --batch --yes --encrypt --recipient 'Lee Phil' "$1.tar.gz"
  fi
  sleep 5
done
