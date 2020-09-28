#!/bin/bash
# create Joker
# time 4/24

init_jumpserver(){
# 生成随机加密秘钥
if [ "$SECRET_KEY" = "" ]; then 
    SECRET_KEY=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 50` 
    echo "SECRET_KEY=$SECRET_KEY" >> ~/.bashrc 
    echo $SECRET_KEY 
    else echo $SECRET_KEY 
fi
if [ "$BOOTSTRAP_TOKEN" = "" ]; then 
    BOOTSTRAP_TOKEN=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 16` 
    echo "BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN" >> ~/.bashrc
    echo $BOOTSTRAP_TOKEN
    else echo $BOOTSTRAP_TOKEN
fi
source ~/.bashrc 
docker run --name Jumpserver \
        -p 80:80 -p 2222:2222 \
        -e SECRET_KEY=$SECRET_KEY \
        -e BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN \
        -d jumpserver/jms_all:latest

# 如果要连接Mysql和redis运行如下
# docker run --name jms_all -d \
#     -v /opt/jumpserver:/opt/jumpserver/data/media \
#     -p 80:80 \
#     -p 2222:2222 \
#     -e SECRET_KEY=xxxxxx \
#     -e BOOTSTRAP_TOKEN=xxx \
#     -e DB_HOST=192.168.x.x \
#     -e DB_PORT=3306 \
#     -e DB_USER=root \
#     -e DB_PASSWORD=xxx \
#     -e DB_NAME=jumpserver \
#     -e REDIS_HOST=192.168.x.x \
#     -e REDIS_PORT=6379 \
#     -e REDIS_PASSWORD=xxx \
#     jumpserver/jms_all:latest
}