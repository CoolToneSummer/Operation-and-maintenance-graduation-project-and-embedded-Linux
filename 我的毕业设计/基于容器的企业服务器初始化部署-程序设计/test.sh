#!/bin/bash
# create Joker
# time 5/12
# 
#Docker部分
docker save -o nginx.tar nginx:latest
docker save > nginx.tar nginx:latest
#其中-o和>表示输出到文件，nginx.tar为目标文件，nginx:latest是源镜像名（name:tag）
docker load -i nginx.tar
docker load < nginx.tar
#其中-i和<表示从文件输入。会成功导入镜像及相关元数据，包括tag信息
docker export -o nginx-test.tar nginx-test
#其中-o表示输出到文件，nginx-test.tar为目标文件，nginx-test是源容器名（name）
docker import nginx-test.tar nginx:imp
cat nginx-test.tar | docker import - nginx:imp
# export命令导出的tar文件略小于save命令导出的
# export命令是从容器（container）中导出tar文件，而save命令则是从镜像（images）中导出
# 基于第二点，export导出的文件再import回去时，无法保留镜像所有历史（即每一层layer信息，不熟悉的可以去看Dockerfile）
# 不能进行回滚操作；而save是依据镜像来的，所以导入时可以完整保留下每一层layer信息
#
# 若是只想备份images，使用save、load即可 
# 若是在启动容器后，容器内容有变化，需要备份，则使用export、import
# save、load使用docker history  nginx:imp有层级可以回滚

docker images | !(head -1) |tr -s " "|cut -d " " -f1 
docker images | awk -F " " '{printf $2}'
docker images | awk 'BEGIN{FS=" "} {print $1,$2}'
docker images | awk 'BEGIN{FS=" "} {print $1":"$2}'

#停止所有容器
docker stop $(docker ps -q)
#删除所有停止容器
docker rm $(docker ps -aq)
#删除所有运行容器
docker stop $(docker ps -q) & docker rm $(docker ps -aq)