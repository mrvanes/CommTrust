#!/bin/sh
docker commit commtrust_srv_1 commtrust-srv:v1
docker commit commtrust_idp_1 commtrust-idp:v1
docker image prune -f
