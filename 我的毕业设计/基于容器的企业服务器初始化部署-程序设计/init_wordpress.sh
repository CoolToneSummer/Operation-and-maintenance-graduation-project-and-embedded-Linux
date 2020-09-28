#!/bin/bash
# create Joker
# time 4/25
# 

init_wordpress(){
docker run --name mariadb-wordpress \
           -e MYSQL_ROOT_PASSWORD=wordpress \
           -d mariadb
docker run --name wordpress-server \
           --link mariadb-wordpress:mysql \
           -p 8084:80 -d wordpress
}