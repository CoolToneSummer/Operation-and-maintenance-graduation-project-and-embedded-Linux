#!/bin/bash
# create Joker
# time 5/25
# 
chksys(){
    echo "#########################系统信息#########################"
    OS_TYPE=`uname`
    OS_VER=`cat /etc/redhat-release`
    OS_KER=`uname -a|awk '{print $3}'`
    OS_TIME=`date +%F_%T`
    OS_RUN_TIME=`uptime |awk '{print $3}'|awk -F, '{print $1}'`
    OS_LAST_REBOOT_TIME=`who -b|awk '{print $2,$3}'`
    OS_HOSTNAME=`hostname`

    echo "    系统类型：$OS_TYPE"
    echo "    系统版本：$OS_VER"
    echo "    系统内核：$OS_KER"
    echo "    当前时间：$OS_TIME"
    echo "    运行时间：$OS_RUN_TIME Day"
    echo "最后重启时间：$OS_LAST_REBOOT_TIME"
    echo "    本机名称：$OS_HOSTNAME"

    echo "#########################网络信息#########################"
    INTERNET=(`ifconfig|grep ens|awk -F: '{print $1}'`)
    for((i=0;i<`echo ${#INTERNET[*]}`;i++))
    do 
        OS_IP=`ifconfig ${INTERNET[$i]}|head -2|grep inet|awk '{print $2}'`
        echo "      本机IP：${INTERNET[$i]}:$OS_IP"
    done
    curl -I http://www.baidu.com &>/dev/null
    if [ $? -eq 0 ]
        then echo "    访问外网：成功"
        else echo "    访问外网：失败"
    fi


    echo "#########################硬件信息#########################"
    CPUID=`grep "physical id" /proc/cpuinfo |sort|uniq|wc -l`
    CPUCORES=`grep "cores" /proc/cpuinfo|sort|uniq|awk -F: '{print $2}'`
    CPUMODE=`grep "model name" /proc/cpuinfo|sort|uniq|awk -F: '{print $2}'`

    echo "     CPU数量: $CPUID"
    echo "     CPU核心:$CPUCORES"
    echo "     CPU型号:$CPUMODE"

    MEMTOTAL=`free -m|grep Mem|awk '{print $2}'`
    MEMFREE=`free -m|grep Mem|awk '{print $7}'`

    echo "  内存总容量: ${MEMTOTAL}MB"
    echo "剩余内存容量: ${MEMFREE}MB"

    disksize=0
    swapsize=`free|grep Swap|awk {'print $2'}`
    partitionsize=(`df -T|sed 1d|egrep -v "tmpfs|sr0"|awk {'print $3'}`)
    for ((i=0;i<`echo ${#partitionsize[*]}`;i++))
    do
        disksize=`expr $disksize + ${partitionsize[$i]}`
    done
    ((disktotal=\($disksize+$swapsize\)/1024/1024))

    echo "  磁盘总容量: ${disktotal}GB"

    diskfree=0
    swapfree=`free|grep Swap|awk '{print $4}'`
    partitionfree=(`df -T|sed 1d|egrep -v "tmpfs|sr0"|awk '{print $5}'`)
    for ((i=0;i<`echo ${#partitionfree[*]}`;i++))
    do
        diskfree=`expr $diskfree + ${partitionfree[$i]}`
    done

    ((freetotal=\($diskfree+$swapfree\)/1024/1024))

    echo "剩余磁盘容量：${freetotal}GB"


    echo "#########################安全信息#########################"

    countuser=(`last|grep "still logged in"|awk '{print $1}'|sort|uniq`)
    for ((i=0;i<`echo ${#countuser[*]}`;i++))
    do echo "当前登录用户：${countuser[$i]}"
    done
    
    # md5sum -c --quiet /opt/passwd.db &>/dev/null
    # if [ $? -eq 0 ]
    #     then echo "    用户异常：否"
    #     else echo "    用户异常：是"
    # fi
}

chksys
