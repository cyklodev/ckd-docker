#!/bin/sh

echo "Add community repository ..."
echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

echo "Reload repositories"
apk update

echo "Add openssl and ca"
apk add ca-certificates openssl
update-ca-certificates

echo "Add git and python3"
apk add git python3

echo "Add pip3"
apk add py3-pip
pip3 install --upgrade pip

echo "Run an interactive shell to hang"
sh
