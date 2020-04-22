#!/bin/sh
mkdir -p commtrust/www
wget https://github.com/simplesamlphp/simplesamlphp/releases/download/v1.18.5/simplesamlphp-1.18.5.tar.gz
cd commtrust
tar -zxf simplesamlphp-1.18.5.tar.gz
docker-compose build --force-rm --no-cache
docker-compose up --no-start
