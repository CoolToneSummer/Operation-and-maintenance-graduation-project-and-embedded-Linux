#!/bin/bash
# create Joker
# time 4/23

init_docker(){
#安装docker及必备组件
yum remove docker \
           docker-client \
           docker-client-latest \
           docker-common \
           docker-latest \
           docker-latest-logrotate \
           docker-logrotate \
           docker-engine
 yum install -y yum-utils \
                device-mapper-persistent-data \
                lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
systemctl start docker
#换docker源
cat >> /etc/docker/daemon.json <<-EOF
{
  "registry-mirrors" : [
    "http://ovfftd6p.mirror.aliyuncs.com",
    "http://registry.docker-cn.com",
    "http://docker.mirrors.ustc.edu.cn",
    "http://hub-mirror.c.163.com"
  ],
  "insecure-registries" : [
    "registry.docker-cn.com",
    "docker.mirrors.ustc.edu.cn"
  ],
  "debug" : true,
  "experimental" : true
}
EOF

#开启portainer端口
firewall-cmd --zone=public --add-port=9000/tcp --permanent &> /dev/null
firewall-cmd --reload &> /dev/null

#docker0网桥开放
nmcli connection modify docker0 connection.zone trusted &> /dev/null
systemctl stop NetworkManager.service
firewall-cmd --permanent --zone=trusted --change-interface=docker0 &> /dev/null
systemctl start NetworkManager.service &> /dev/null
nmcli connection modify docker0 connection.zone trusted &> /dev/null
systemctl restart docker.service &> /dev/null

#安装portainer
docker run -d -p 9000:9000 \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name prtainer \
    docker.io/portainer/portainer
}