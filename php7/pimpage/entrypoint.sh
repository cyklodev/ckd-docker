#!/bin/sh

echo "Add community repository ..."
echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

echo "Reload repositories"
apk update

echo "Add php7-curl ext"
apk add php7-curl

echo "Add php7-curl ext"
apk add php7-sqlite3

echo "Add openssl and ca"
apk add ca-certificates openssl
update-ca-certificates

echo "Run an interactive shell to hang"
cd /app
php -S 0.0.0.0:80 >> /app/access.log 

echo "You will never see this"

