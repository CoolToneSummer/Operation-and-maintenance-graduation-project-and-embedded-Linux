#!/bin/bash
# create Joker
# time 4/26
#

redis_colony(){
pip3 install docker-compose
if [[ $? -eq 0 ]];then
    echo "正在初始化创建redis集群！请等待！"
    cd ./docker_redis_cluster/
    docker-compose up -d
    cd ..
else
    echo "您的python3环境有问题,请先配置python3环境!"
fi
}