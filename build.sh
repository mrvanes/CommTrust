#!/bin/sh
git clone git@github.com:sgomez/commtrust-demonstrator.git
docker-compose build --force-rm --no-cache
docker-compose up --no-start
