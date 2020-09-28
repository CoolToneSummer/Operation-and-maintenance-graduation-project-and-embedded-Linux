#!/bin/bash
# create Joker
# time 4/25
# 
#colorList=([1]=\033[31m [2]=\033[32m [3]=\033[33m [4]=\033[34m [5]=\033[35m [6]=\033[36m)
colorList=("\033[31m" "\033[32m" "\033[33m" "\033[34m" "\033[35m" "\033[36m")
#[0]红[1]黄[2]绿[3]蓝[4]紫[5]青
numberRange=$((RANDOM%6))
for i in `seq 0 $[${#colorList[*]}-1]`
do
    #if [ ${#colorList[i]} -eq $numberRange ];then
    if [ $i -eq $numberRange ];then
        rColor="${colorList[i]}"
    fi
done

numberTwoRange=$((RANDOM%6))
for i in `seq 0 $[${#colorList[*]}-1]`
do
    #if [ ${#colorList[i]} -eq $numberRange ];then
    if [ $i -eq $numberTwoRange ];then
        rTwoColor="${colorList[i]}"
    fi
done

twinkleColor="\033[5;31m"
eColor="\033[0m"

funListPort(){
    while :
    do
        echo -e "$rColor*******************************************$eColor"
        echo -e "$twinkleColor***************Version:"`firewall-cmd --version`"***************$eColor"
        echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
        echo -e "$rColor**   请选择需要使用的功能(输入编号)        **$eColor"
        echo -e "$rColor**   1:查看防火墙开放的端口信息           **$eColor"
        echo -e "$rColor**   2:查看防火墙所有信息                 **$eColor"
        echo -e "$rColor**   3:导出防火墙信息到port.txt           **$eColor"
        echo -e "$rColor**   q:返回上级目录                        **$eColor"
        echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
        echo -e "$rColor*******************************************$eColor"
        read aNum
        case $aNum in
            1)  echo -e "$rTwoColor 您选择了 1$eColor"
                echo -e "$rTwoColor 该服务器防火墙所开启的端口如下：$eColor"
                firewall-cmd --permanent --list-port
            ;;
            2)  echo -e "$rTwoColor 您选择了 2$eColor"
                echo -e "$rTwoColor 该服务器防火墙所有信息如下：$eColor"
                firewall-cmd --list-all
            ;;
            3)  echo -e "$rTwoColor 您选择了 3$eColor"
                firewall-cmd --list-all > port.txt
                echo -e "$rTwoColor 导出成功！$eColor"
            ;;
            q)  echo -e "$rTwoColor 正在返回上级目录！$eColor"
                break
            ;;
        esac
    done
}
# 下面代码有点冗余 懒得改了 等有时间再看吧
funOnePort(){
    while :
    do
        echo -e "$rTwoColor 请选择您与需要开启的端口类型(t/tcp,u/udp)：$eColor"
        read sPort
        if [[ $sPort == t || $sPort == tcp ]]
        then
            echo -e "$rTwoColor 请输入您需要开启的端口(例:3306)：$eColor"
            read oPort
            firewall-cmd --zone=public --add-port=$oPort/tcp --permanent &> /dev/null
            if [ $? -eq 0 ]; then echo -e "$rTwoColor 开启TCP:$oPort端口成功！$eColor";else echo -e "$rTwoColor 输入格式错误！$eColor"; fi
        elif [[ $sPort == u || $sPort == udp ]]
        then
            echo -e "$rTwoColor 请输入您需要开启的端口(例:3306)：$eColor"
            read oPort
            firewall-cmd --zone=public --add-port=$oPort/udp --permanent &> /dev/null
            if [ $? -eq 0 ]; then echo -e "$rTwoColor 开启UDP:$oPort端口成功！$eColor";else echo -e "$rTwoColor 输入格式错误！$eColor"; fi
        else
            echo -e "$rTwoColor 输入格式有误,请重新输入！$eColor"
        fi
        echo -e "$rTwoColor 是否继续或返回上级目录?(输入b/break返回,其他键继续!)$eColor"
        read ret
        if [[ $ret == "b" || $ret == "break" ]];then break;else continue; fi
    done
}

funStopOnePort(){
    while :
    do
        echo -e "$rTwoColor 请选择您与需要关闭的端口类型(t/tcp,u/udp)：$eColor"
        read sPort
        if [[ $sPort == t || $sPort == tcp ]]
        then
            echo -e "$rTwoColor 请输入您需要关闭的端口(例:3306)：$eColor"
            read oPort
            firewall-cmd --zone=public --remove-port=$oPort/tcp --permanent &> /dev/null
            if [ $? -eq 0 ]; then echo -e "$rTwoColor 关闭TCP:$oPort端口成功！$eColor";else echo -e "$rTwoColor 输入格式错误！$eColor"; fi
        elif [[ $sPort == u || $sPort == udp ]]
        then
            echo -e "$rTwoColor 请输入您需要关闭的端口(例:3306)：$eColor"
            read oPort
            firewall-cmd --zone=public --remove-port=$oPort/udp --permanent &> /dev/null
            if [ $? -eq 0 ]; then echo -e "$rTwoColor 关闭UDP:$oPort端口成功！$eColor";else echo -e "$rTwoColor 输入格式错误！$eColor"; fi
        else
            echo -e "$rTwoColor 输入格式有误,请重新输入！$eColor"
        fi
        echo -e "$rTwoColor 是否继续或返回上级目录?(输入b/break返回,其他键继续!)$eColor"
        read ret
        if [[ $ret == "b" || $ret == "break" ]];then break;else continue; fi
    done
}

funSectionPort(){
    while :
    do
        echo -e "$rTwoColor 请选择您与需要开启的端口区间类型(t/tcp,u/udp)：$eColor"
        read sPort
        if [[ $sPort == t || $sPort == tcp ]]
        then
            echo -e "$rTwoColor 请输入您需要开启的端口区间起始端口(例:3306)：$eColor"
            read startPort
            echo -e "$rTwoColor 请输入您需要开启的端口区间结束端口(例:3308)：$eColor"
            read endPort
            firewall-cmd --zone=public --add-port=$startPort-$endPort/tcp --permanent &> /dev/null
            if [ $? == 0 ]; then echo -e "$rTwoColor 开启TCP:$startPort-$endPort端口成功！$eColor";else echo -e "$rTwoColor 输入格式错误！$eColor"; fi
        elif [[ $sPort == u || $sPort == udp ]]
        then
            echo -e "$rTwoColor 请输入您需要开启的端口区间起始端口(例:3306)：$eColor"
            read startPort
            echo -e "$rTwoColor 请输入您需要开启的端口区间结束端口(例:3308)：$eColor"
            read endPort
            firewall-cmd --zone=public --add-port=$startPort-$endPort/udp --permanent &> /dev/null
            if [ $? == 0 ]; then echo -e "$rTwoColor 开启UDP:$startPort-$endPort端口成功！$eColor";else echo -e "$rTwoColor 输入格式错误！$eColor"; fi
        else
            echo -e "$rTwoColor 输入格式有误,请重新输入！$eColor"
        fi
        echo -e "$rTwoColor 是否继续或返回上级目录?(输入b/break返回,其他键继续!)$eColor"
        read ret
        if [[ $ret == "b" || $ret == "break" ]];then break;else continue; fi
    done
}

funStopSectionPort(){
    while :
    do
        echo -e "$rTwoColor 请选择您与需要关闭的端口区间类型(t:tcp,u:udp)：$eColor"
        read sPort
        if [[ $sPort == t || $sPort == tcp ]]
        then
            echo -e "$rTwoColor 请输入您需要关闭的端口区间起始端口(例:3306)：$eColor"
            read startPort
            echo -e "$rTwoColor 请输入您需要关闭的端口区间结束端口(例:3308)：$eColor"
            read endPort
            firewall-cmd --zone=public --remove-port=$startPort-$endPort/tcp --permanent &> /dev/null
            if [ $? == 0 ]; then echo -e "$rTwoColor 关闭TCP:$startPort-$endPort端口成功！$eColor";else echo -e "$rTwoColor 输入格式错误！$eColor"; fi
        elif [[ $sPort == u || $sPort == udp ]]
        then
            echo -e "$rTwoColor 请输入您需要关闭的端口区间起始端口(例:3306)：$eColor"
            read startPort
            echo -e "$rTwoColor 请输入您需要关闭的端口区间结束端口(例:3308)：$eColor"
            read endPort
            firewall-cmd --zone=public --remove-port=$startPort-$endPort/udp --permanent &> /dev/null
            if [ $? == 0 ]; then echo -e "$rTwoColor 关闭UDP:$startPort-$endPort端口成功！$eColor";else echo -e "$rTwoColor 输入格式错误！$eColor"; fi
        else
            echo -e "$rTwoColor 输入格式有误,请重新输入！$eColor"
        fi
        echo -e "$rTwoColor 是否继续或返回上级目录?(输入b/break返回,其他键继续!)$eColor"
        read ret
        if [[ $ret == "b" || $ret == "break" ]];then break;else continue; fi
    done
}

funSEController(){
    while :
    do
        echo -e "$rColor*******************************************$eColor"
        echo -e "$twinkleColor***************Version:"`firewall-cmd --version`"***************$eColor"
        echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
        echo -e "$rColor**   请选择需要使用的功能(输入编号)        **$eColor"
        echo -e "$rColor**   1:查看SELinux是否开启(状态)            **$eColor"
        echo -e "$rColor**   2:暂时关闭SELinux                   **$eColor"
        echo -e "$rColor**   3:永久关闭SELinux                   **$eColor"
        echo -e "$rColor**   4:永久开启SELinux                   **$eColor"
        echo -e "$rColor**   q:返回上级目录                        **$eColor"
        echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
        echo -e "$rColor*******************************************$eColor"
        read aNum
        case $aNum in
            1)  echo -e "$rTwoColor 您选择了 1$eColor"
                echo -e "$rTwoColor SELinux是否开启(状态)如下：$eColor"
                getenforce &> /dev/null
                if [[ `getenforce` == "Disabled" ]];then
                    echo -e "$rTwoColor 您的SELinux未开启！$eColor" 
                elif [[ `getenforce` == "Permissive" ]];then
                    echo -e "$rTwoColor 您的SELinux是关闭的！$eColor" 
                elif [[ `getenforce` == "Enforcing" ]];then
                    echo -e "$rTwoColor 您的SELinux是开启的！$eColor" 
                else
                    echo -e "$rTwoColor 未知错误！$eColor" 
                fi
            ;;
            2)  echo -e "$rTwoColor 您选择了 2$eColor"
                setenforce 0 &> /dev/null
                echo -e "$rTwoColor 暂时关闭SELinu成功！$eColor"
            ;;
            3)  echo -e "$rTwoColor 您选择了 3$eColor"
                setenforce 0 &> /dev/null
                sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
                echo -e "$rTwoColor 永久关闭SELinux成功！$eColor"
            ;;
            4)  echo -e "$rTwoColor 您选择了 4$eColor"
                setenforce 1 &> /dev/null
                sed -i "s/SELINUX=disabled/SELINUX=enforcing/g" /etc/selinux/config
                echo -e "$rTwoColor 永久开启SELinux成功！$eColor"
                echo -e "$rTwoColor 但是必须重启计算机后才能生效！$eColor"
            ;;
            q)  echo -e "$rTwoColor 正在返回上级目录！$eColor"
                break
            ;;
        esac
    done
}

funREADME(){
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rTwoColor 为什么不直接关闭防火墙?$eColor"
    echo -e "$rTwoColor 防火墙就和你家的门一样,关闭防火墙就像你家的门没了一样！一般情况下不要关闭防火墙！$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rTwoColor 为什么要开启防火墙某些端口?$eColor"
    echo -e "$rTwoColor 比方说你家养了宠物,门下面给它开了个小洞！$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rTwoColor 什么是SELinux?$eColor"
    echo -e "$rTwoColor 就像你们家卧室的门一样,这个比较麻烦,默认是开启的,没有特殊情况直接关闭就好了,$eColor"
    echo -e "$rTwoColor 对你的影响不是很大,如果开启的话Docker,nginx等所有的服务都要设置策略,相当让人头疼！$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rTwoColor 下次使用本程序找不到放哪了?$eColor"
    echo -e "$rTwoColor 啊哈哈哈,别担心,不管在哪,直接使用cocofirewalld动本程序！ $eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$twinkleColor 警告:没有特殊需求不要永久打开SELinux！(虽然SELinux默认是打开的)$eColor"
    echo -e "$twinkleColor 您在有必要的时候可以选择暂时关闭或永久关闭SELinux！$eColor"
    echo -e "$rColor*******************************************$eColor"
}

#如何防止自己的云服务器被暴力破解密码完整搭建流程请看我的CSDN博客
#https://blog.csdn.net/qq_40695642/article/details/105104395
funBruteForce(){
    echo -e "$rTwoColor 正在安装邮件服务。。。 $eColor"
    yum -y install mailx jwhois &> /dev/null
    if [[ $? -eq 0 ]];then
        \\cp -p ./.mailrc ~
        lastb | sed -rn '/ssh:/p' | tr -s " " | cut -d " " -f3 | sort | uniq -c | while read count ip;do
        if [[ $count -gt 3 ]];then
            firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="$ip" port protocol="tcp" port="22" reject" &> /dev/null
            firewall-cmd --reload &> /dev/null
            echo "$ip尝试登录您的服务器三次,已经被加入防火墙！" | mail -s "阿里云服务器登录失败IP提醒" 2351147520@qq.com
            fi
        done
    else
        echo -e "$rTwoColor 邮件服务未安装成功，请安装后再试！ $eColor" 
    fi
}

firewalldMain(){
    alias cocofirewalld="$0" &> /dev/null
    \\cp -p $0 /usr/local/sbin/ &> /dev/null
    \\cp -p $0 /usr/bin/ &> /dev/null
    while :
    do
        firewall-cmd --state &> /dev/null
        if [[ $? -eq 0 ]];then
            echo -e "$rColor*******************************************$eColor"
            echo -e "$twinkleColor***************Version:"`firewall-cmd --version`"***************$eColor"
            echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
            echo -e "$rColor**   请选择需要使用的功能(输入编号)       **$eColor"
            echo -e "$rColor**   1:开启防火墙已关闭的端口              **$eColor"
            echo -e "$rColor**   2:关闭防火墙已开启的端口              **$eColor"
            echo -e "$rColor**   3:开启特定区间内的防火墙端口         **$eColor"
            echo -e "$rColor**   4:关闭特定区间内的防火墙端口         **$eColor"
            echo -e "$rColor**   5:SELinux控制                      **$eColor"
            echo -e "$rColor**   6:防止SSH暴力破解服务器              **$eColor"
            echo -e "$rColor**   7:README[使用前必读]                 **$eColor"
            echo -e "$rColor**   0:查看该服务器开启的所有防火墙端口   **$eColor"
            echo -e "$rColor**   q:退出                             **$eColor"
            echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
            echo -e "$rColor*******************************************$eColor"
            read aNum
            case $aNum in
                1)  echo -e "$rTwoColor 您选择了 1$eColor"
                    funOnePort
                ;;
                2)  echo -e "$rTwoColor 您选择了 2$eColor"
                    funStopOnePort
                ;;
                3)  echo -e "$rTwoColor 您选择了 3$eColor"
                    funSectionPort
                ;;
                4)  echo -e "$rTwoColor 您选择了 4$eColor"
                    funStopSectionPort
                ;;
                5)  echo -e "$rTwoColor 您选择了 5$eColor"
                    funSEController
                ;;
                6)  echo -e "$rTwoColor 您选择了 6$eColor"
                    funBruteForce
                ;;
                7)  echo -e "$rTwoColor 您选择了 7$eColor"
                    funREADME
                ;;
                0)  echo -e "$rTwoColor 您选择了 0$eColor"
                    funListPort
                ;;
                q)  echo -e "$rTwoColor 再见！$eColor"
                    firewall-cmd --reload &> /dev/null
                    break
                ;;
            esac
        else
            echo -e "$twinkleColor 您没有开启防火墙或防火墙启动失败,是否重新开启?(y/yes开启)$eColor"
            read rStart
            if [[ $rStart == "y" || $rStart == "yes" ]];then 
                systemctl start firewalld  &> /dev/null
                firewall-cmd --state &> /dev/null
                if [[ $? -eq 0 ]];then
                    echo -e "$rTwoColor 防火墙开启成功!$eColor"
                    continue
                else
                    echo -e "$rTwoColor 防火墙开启失败!$eColor"
                    echo -e "$rTwoColor 防火墙失败状态日志保存在当前目录:firewalld-fail.log$eColor"
                    systemctl status firewalld > firewalld-fail.log 
                    break
                fi
            else 
                echo -e "$rTwoColor 再见！$eColor"
                break
            fi
        fi
    done
}

