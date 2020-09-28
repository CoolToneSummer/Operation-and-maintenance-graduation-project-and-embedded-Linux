#!/bin/bash
# create Joker
# time 5/14
# 

#ELK部署启动失败问题解决
#https://blog.csdn.net/bluetjs/article/details/78770447
#elasticsearch用户拥有的内存权限太小，至少需要262144
init_elk(){
sysctl -w vm.max_map_count=262144
echo vm.max_map_count=262144 >> /etc/sysctl.conf
sysctl -p
# echo "* soft nofile 65536" > /etc/security/limits.conf
# echo "* hard nofile 131072" > /etc/security/limits.conf
docker run -d -p 5601:5601 \
                -p 9200:9200 \
                -p 5044:5044 \
                -e ES_MIN_MEM=128m \
                -e ES_MAX_MEM=1024m \
                -it --name elk22 sebp/elk

}