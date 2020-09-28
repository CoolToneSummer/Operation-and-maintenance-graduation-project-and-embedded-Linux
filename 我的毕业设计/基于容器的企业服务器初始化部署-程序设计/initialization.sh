#!/bin/bash
# create Joker
# time 4/23
#
. cocofirewalld.sh
. coconetwork.sh
. init_docker.sh
. init_jumpserver.sh
. redis_colony.sh
. init_python.sh
. kernel_update.sh
. init_elk.sh
. init_zabbix.sh
. chksys.sh

h=`date +%H`
if [ $h -ge 0 ] && [ $h -lt 12 ]
then
    echo "Good morning."
elif [ $h -ge 12 ] && [ $h -lt 18 ]
then
    echo "Good afternoon."
else
    echo "Good evening."
fi

echo "是否开始初始化服务器(y/n)"
read ret
if [[ $ret == "y" || $ret == "yes" ]];then


    echo "开始安装必备组件包..."
    sleep 2
    #全局安装组件
    yum install net-tools vim wget curl -y
    yum install wget gcc epel-release git dos2unix -y
    yum install -y lrzsz \
                zip \
                unzip
    #阿里云换源
    sleep 2
    # echo "正在更换阿里云yum源..."
    # mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    # wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  
    # yum clean all
    # yum makecache
    # if [[ $? -eq 0 ]];then
    #     echo "切换阿里云yum源成功!"
    # else
    #     echo "请使用yum makecache手动更新yum源!"
    # fi
    #中文

    echo "正在切换中文..."
    sleep 2
    localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8
    export LC_ALL=zh_CN.UTF-8
    echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf
    echo "中文切换完成!"
    sleep 2
    echo "正在修改终端颜色..."
    sleep 2
    setenforce 0
    PS1="\[\e[35;40m\][\[\e[31;40m\]\u\[\e[33;40m\]@\h \[\e[36;40m\]\w\[\e[0m\]]\\$"
    #改变终端颜色
cat >> ~/.bashrc <<-EOF
PS1="\[\e[35;40m\][\[\e[31;40m\]\u\[\e[33;40m\]@\h \[\e[36;40m\]\w\[\e[0m\]]\\$"
EOF
    source ~/.bashrc
echo "终端颜色修改成功!"

#打开extglob 
#rm -ef !(file)
shopt -s extglob
clear
fi


init_main(){
    while :
    do
        echo -e "$rColor**********************************************$eColor"
        echo -e "$twinkleColor******************Wellcome!!!*******************$eColor"
        echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++++++**$eColor"
        echo -e "$rColor** @@@@@ 注意:您的服务器最低配置要求为2核4G @@@@@ **$eColor"
        echo -e "$rColor**   请选择需要使用的功能(输入编号)          **$eColor"
        echo -e "$rColor**   1:更新服务器内核以及BASH(重启后生效)    **$eColor"
        echo -e "$rColor**   2:安装初始化Python3环境                **$eColor"
        echo -e "$rColor**   3:安装初始化Docker环境                 **$eColor"
        echo -e "$rColor**   4:Docker安装初始化elk日志监控实例         **$eColor"
        echo -e "$rColor**   5:Docker安装初始化Zabbix性能监控实例      **$eColor"
        echo -e "$rColor**   6:Docker安装初始化Jumpserver跳板机      **$eColor"
        echo -e "$rColor**   7:Docker-Compose搭建redis三主三从集群   **$eColor"
        echo -e "$rColor**   8:cocofirewalld防火墙策略               **$eColor"
        echo -e "$rColor**   9:coconetwork网络连接策略               **$eColor"
        echo -e "$rColor**   a:查看服务器基础信息                    **$eColor"
        echo -e "$rColor**   q:退出                                 **$eColor"
        echo -e "$rColor**++++++++++++++++++++++++++++++++++++++++++++**$eColor"
        echo -e "$rColor************************************************$eColor"
        read aNum
        case $aNum in
            1)  echo -e "$rTwoColor 您选择了 1$eColor"
                echo -e "$rTwoColor 更新服务器内核以及BASH(重启后生效) $eColor"
                kernel_update
            ;;
            2)  echo -e "$rTwoColor 您选择了 2$eColor"
                echo -e "$rTwoColor 安装初始化Python3环境 $eColor"
                init_python
            ;;
            3)  echo -e "$rTwoColor 您选择了 3$eColor"
                echo -e "$rTwoColor 安装初始化Docker环境 $eColor"
                init_docker
            ;;
            4)  echo -e "$rTwoColor 您选择了 4$eColor"
                echo -e "$rTwoColor Docker安装初始化elk日志监控实例 $eColor"
                init_elk
            ;;
            5)  echo -e "$rTwoColor 您选择了 5$eColor"
                echo -e "$rTwoColor Docker安装初始化Zabbix监控实例 $eColor"
                init_zabbix
            ;;
            6)  echo -e "$rTwoColor 您选择了 6$eColor"
                echo -e "$rTwoColor Docker安装初始化Jumpserver跳板机 $eColor"
                init_jumpserver
            ;;
            7)  echo -e "$rTwoColor 您选择了 7$eColor"
                echo -e "$rTwoColor Docker-Compose搭建redis三主三从集群 $eColor"
                redis_colony
            ;;
            8)  echo -e "$rTwoColor 您选择了 8$eColor"
                echo -e "$rTwoColor cocofirewalld防火墙策略 $eColor"
                firewalldMain
            ;;
            9)  echo -e "$rTwoColor 您选择了 9$eColor"
                echo -e "$rTwoColor coconetwork网络连接策略 $eColor"
                networkMain
            ;;
            a)  echo -e "$rTwoColor 您选择了 a$eColor"
                echo -e "$rTwoColor 查看服务器基础信息 $eColor"
                chksys
            ;;
            q)  echo -e "$rTwoColor 再见！ $eColor"
                break
            ;;
        esac
    done
}

init_main


