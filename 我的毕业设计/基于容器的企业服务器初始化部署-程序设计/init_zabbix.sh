#!/bin/bash
# create Joker
# time 4/24

init_zabbix(){
#首先，启动空的 MySQL 服务器实例。
docker run --name mysql-server -t \
      -p 3306:3306 \
      -v /var/zdocker/data:/var/lib/mysql \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="root" \
      -d mysql:5.7 \
      --character-set-server=utf8 --collation-server=utf8_bin
#启动 Zabbix server 实例，并将其关联到已创建的 MySQL server 实例。
docker run --name zabbix-server-mysql -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="root" \
      --link mysql-server:mysql \
      -p 10051:10051 \
      -d zabbix/zabbix-server-mysql:latest
#Zabbix server 实例将 10051/TCP 端口（Zabbix trapper）暴露给主机。
#启动 Zabbix Web 界面，并将其关联到已创建的 MySQL server 和 Zabbix server 实例
docker run --name zabbix-web-nginx-mysql -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="root" \
      --link mysql-server:mysql \
      --link zabbix-server-mysql:zabbix-server \
      -p 80:80 \
      -d zabbix/zabbix-web-nginx-mysql:latest
}