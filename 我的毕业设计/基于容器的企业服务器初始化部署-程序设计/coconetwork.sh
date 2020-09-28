#!/bin/bash
# create Joker
# time 4/25
# 

# cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 50 生成随机密码
#

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

function checkIp() {
    local IP=$1
    VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
    if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" >/dev/null; then
        if [ $VALID_CHECK == "yes" ]; then
         echo -e "$rTwoColor IP $IP  可用！$eColor"
            return 0
        else
            echo -e "$rTwoColor IP $IP 不可用！$eColor"
            return 1
        fi
    else
        echo -e "$rTwoColor IP 格式错误！$eColor"
        return 1
    fi
}

funIPInformation(){
    while :
    do
        echo -e "$rColor*******************************************$eColor"
        echo -e "$twinkleColor*****************Wellcome!!!****************$eColor"
        echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
        echo -e "$rColor**   请选择需要使用的功能(输入编号)        **$eColor"
        echo -e "$rColor**   1:查看当前服务器使用的IP地址          **$eColor"
        echo -e "$rColor**   2:查看当前服务器使用的MAC地址         **$eColor"
        echo -e "$rColor**   3:查看当前服务器的网卡详细信息        **$eColor"
        echo -e "$rColor**   q:返回上级目录                       **$eColor"
        echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
        echo -e "$rColor*******************************************$eColor"
        read aNum
        case $aNum in
            1)  echo -e "$rTwoColor 您选择了 1$eColor"
                echo -e "$rTwoColor 该服务器正在使用的IP地址：$eColor"
                serverIP=`ip addr | grep 'state UP' -A2 | grep inet | egrep -v '(127.0.0.1|inet6|docker)' | awk '{print $2}' | tr -d "addr:" | head -n 1 | cut -d / -f1`
                # printf "$serverIP \n" 
                echo $serverIP
            ;;
            2)  echo -e "$rTwoColor 您选择了 2$eColor"
                echo -e "$rTwoColor 该服务器正在使用的MAC地址：$eColor"
                serverMAC=`ip addr | grep 'state UP' -A2 | grep link | egrep -v '(127.0.0.1|inet6|docker)' | awk '{print $2}'`
                echo $serverMAC
            ;;
            3)  echo -e "$rTwoColor 您选择了 3$eColor"
                echo -e "$rTwoColor 当前服务器的网卡详细信息：$eColor"
                ifconfig &> /dev/null
                if [[ $? -eq 0 ]];then
                    ifconfig
                else
                    ip addr
                fi
            ;;
            q)  echo -e "$rTwoColor 正在返回上级目录！$eColor"
                break
            ;;
        esac
    done
}

funModifyStaticIP(){
    eth=`find /etc/sysconfig/network-scripts/ -name "ifcfg-e*" |sort |head -1 |awk -F/ '{print $5}'`
    ethfile="/etc/sysconfig/network-scripts/$eth"
    \\cp -p $ethfile $ethfile.bak &> /dev/null
    while :
    do
        echo -e "$rTwoColor 输入完成后您可以最后确认一次！(子网掩码和网关暂时就不做校验了~)$eColor"
        while true; do
            echo -e "$rTwoColor 请输入你想要修改的IP：$eColor"
            # read -p "请输入你想要修改的IP：" IP
            read mIP
            checkIp $mIP
            [ $? -eq 0 ] && break
        done
        echo -e "$rTwoColor 请输入你想要修改的子网掩码：(不输入默认255.255.255.0)$eColor"
        read mMASK
        echo -e "$rTwoColor 请输入你想要修改的网关：(不输入默认为刚输入的网段+254结尾的默认网关)$eColor"
        read mGATEWAY
        
        echo -e "$rTwoColor 您输入的IP为：${mIP} $eColor"
        echo -e "$rTwoColor 您输入的IP为：${mMASK:-255.255.255.0} $eColor"
        echo -e "$rTwoColor 您输入的IP为：${mGATEWAY:-${mIP%.*}.254} $eColor"
        echo -e "$rTwoColor 确定要修改吗?(y/yes确定)$eColor"
        read fix
        if [[ $fix == y || $fix == yes ]];then
            sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/g' "${ethfile}"
            sed -i 's/^ONBOOT=no/ONBOOT=yes/g' "${ethfile}"
            #testfile="/etc/sysconfig/network-scripts/test"
            #修改配置文件 没有--追加 有--替换
            #可以换成case更简单 这里也是懒得改了
            grep -i "IPADDR" "${ethfile}" > /dev/null
            if [ $? -eq 0 ]; then
                # grep -i "IPADDR*" "${ethfile}" | awk -F "=" '{printf $2}'
                tmp=`grep -i "IPADDR" ${ethfile}`
                sed -i "s/^${tmp}/IPADDR=${mIP}/g" "${ethfile}"
            else
                echo "IPADDR=${mIP}" >>${ethfile}
            fi
            grep -i "NETMASK" "${ethfile}" > /dev/null
            if [ $? -eq 0 ]; then
                tmp=`grep -i "NETMASK" ${ethfile}`
                sed -i "s/^${tmp}/NETMASK=${mMASK:-255.255.255.0}/g" "${ethfile}"
            else
                 # ${mMASK:-255.255.255.0} 参数为空字符或者null 设置默认值
                echo "NETMASK=${mMASK:-255.255.255.0}" >>${ethfile} 
            fi
            grep -i "GATEWAY" "${ethfile}" > /dev/null
            if [ $? -eq 0 ]; then
                tmp=`grep -i "GATEWAY" ${ethfile}`
                sed -i "s/^${tmp}/GATEWAY=${mGATEWAY:-${mIP%.*}.254}/g" "${ethfile}"
            else
                #${mGATEWAY:-${mIP%.*}.254} 设置默认值截取输入IP最后一个点之前+.254
                echo "GATEWAY=${mGATEWAY:-${mIP%.*}.254}" >>${ethfile}
            fi  
            ifdown `echo $eth | awk -F "-" '{printf $2}'` &> /dev/null
            ifup `echo $eth | awk -F "-" '{printf $2}'` &> /dev/null
            service network restart &> /dev/null
            if [[ $? -eq 0 ]];then
                echo -e "$rTwoColor 配置生效！$eColor"
                echo -e "$rTwoColor 现在您的网卡配置情况如下：$eColor"
                echo -e "$rTwoColor IPADDR=${mIP} $eColor" 
                echo -e "$rTwoColor NETMASK=${mMASK:-255.255.255.0} $eColor"
                echo -e "$rTwoColor GATEWAY=${mGATEWAY:-${mIP%.*}.254} $eColor"
                echo -e "$rTwoColor 是否重新修改或返回上级目录?(输入b/break返回,其他键继续!)$eColor"
                read ret
                if [[ $ret == "b" || $ret == "break" ]];then break;else continue; fi
            else
                echo -e "$rTwoColor 配置失败,请排完错误后重试！$eColor"
                systemctl status network > network-faild.log

                echo -e "$rTwoColor 错误日志在network-faild.log中！$eColor"
                break
            fi
        else
            echo -e "$rTwoColor 是否重新修改或返回上级目录?(输入b/break返回,其他键继续!)$eColor"
            read ret
            if [[ $ret == "b" || $ret == "break" ]];then break;else continue; fi
        fi
    done
}

funModifyDynamicIP(){
    \\cp -p $ethfile $ethfile.bak &> /dev/null
    eth=`find /etc/sysconfig/network-scripts/ -name "ifcfg-e*" |sort |head -1 |awk -F/ '{print $5}'`
    ethfile="/etc/sysconfig/network-scripts/$eth"
    while :
    do
        echo -e "$rTwoColor 您当前网卡配置如下：$eColor"
        echo -e "$rTwoColor 是否确定要配置成动态IP?(y/yes确定)$eColor"
        read fix
        if [[ $fix == "y" || $fix == "yes" ]];then
            sed -i 's/BOOTPROTO=static/BOOTPROTO=dhcp/g' "${ethfile}"
            sed -i 's/^ONBOOT=no/ONBOOT=yes/g' "${ethfile}"
            tmpIp=`grep -i "IPADDR" ${ethfile}`
            if [[ $? -eq 0 ]];then
                sed -i "s/^${tmpIp}/''/g" "${ethfile}"
            fi
            tmpMask=`grep -i "NETMASK" ${ethfile}`
            if [[ $? -eq 0 ]];then
                sed -i "s/^${tmpMask}/''/g" "${ethfile}"
            fi
            tmpGateWay=`grep -i "GATEWAY" ${ethfile}`
            if [[ $? -eq 0 ]];then
                sed -i "s/^${tmpGateWay}/''/g" "${ethfile}"
            fi
            ifdown `echo $eth | awk -F "-" '{printf $2}'` &> /dev/null
            ifup `echo $eth | awk -F "-" '{printf $2}'` &> /dev/null
            service network restart &> /dev/null
            if [[ $? -eq 0 ]];then
                echo -e "$rTwoColor 修改生效！$eColor"
                echo -e "$rTwoColor 现在您的网卡配置情况如下：$eColor"
                ifconfig &> /dev/null
                if [[ $? -eq 0 ]];then
                    ifconfig
                else
                    ip addr
                fi
                echo -e "$rTwoColor 是否重新修改或返回上级目录?(输入b/break返回,其他键继续!)$eColor"
                read ret
                if [[ $ret == "b" || $ret == "break" ]];then break;else continue; fi
            else
                echo -e "$rTwoColor 配置失败,请排完错误后重试！"
                systemctl status network > network-faild.log
                echo -e "$rTwoColor 错误日志在network-faild.log中！"
                break
            fi
        else
            echo -e "$rTwoColor 是否重新修改或返回上级目录?(输入b/break返回,其他键继续!)$eColor"
            read ret
            if [[ $ret == "b" || $ret == "break" ]];then break;else continue; fi
        fi
    done
}

funSpeedTest(){
    ping www.baidu.com -c 2 &> /dev/null
    if [[ $? -eq 0 ]];then
        echo -e "$rTwoColor 您的网络通畅,接下来测试网速,请等待片刻...$eColor"
        curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
        if [[ $? -ne 0 ]];then
            wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
            if [[ $? -eq 0 ]];then
                python3 speedtest.py
            else
                echo -e "$rTwoColor 请检查python3是否安装好！$eColor"
            fi
        fi
    else
        echo -e "$rTwoColor 您的网络不通畅,请检查网络配置!$eColor"
    fi
}

funEth0(){
    #修改网卡名称
    sed -i.bak -r '/GRUB_CMDLINE_LINUX/s@(.*)"$@\1 net.ifnames=0"@' /etc/default/grub
    grub2-mkconfig -o /etc/grub2.cfg &> /dev/null
    if [[ $? -eq 0 ]];then
        echo -e "$rTwoColor 修改网卡名称为eth0成功！重启服务器后生效！$eColor"
    else 
        \\mv -f /etc/default/grub.bak /etc/default/grub &> /dev/null
        echo -e "$rTwoColor 修改出现问题了,配置文件已回滚！$eColor"
    fi
}

funREADME(){
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rTwoColor 什么是静态,什么是动态IP?$eColor"
    echo -e "$rTwoColor 静态IP是自己配置的IP,配置完成后IP固定不变$eColor"
    echo -e "$rTwoColor 动态IP是由DHCP服务器所自动下发的IP,一段时间不使用,会被DHCP服务器回收,等使用是下发新的IP$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rTwoColor 当安装完成一个服务器后第一件事情就是配置IP$eColor"
    echo -e "$rTwoColor 因为默认网卡是关闭的,你必须打开网卡,并配置使用动态或静态IP$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$twinkleColor 警告:在使用云服务器时候禁止修改网卡为静态IP！(云服务器默认设置了,否则可能会宕机！)$eColor"
    echo -e "$twinkleColor 当您全新配置一个物理服务器时候才可以使用2,3功能！！！$eColor"
    echo -e "$rColor*******************************************$eColor"
    echo -e "$rTwoColor 下次使用本程序找不到放哪了?$eColor"
    echo -e "$rTwoColor 啊哈哈哈,别担心,不管在哪,直接使用coconetwork启动本程序！$eColor"
    echo -e "$rColor*******************************************$eColor"
}

networkMain(){
    alias coconetwork="$0" &> /dev/null
    \\cp -p $0 /usr/local/sbin/ &> /dev/null
    \\cp -p $0 /usr/bin/ &> /dev/null
    while :
    do
        systemctl status network &> /dev/null
        if [[ $? -eq 0 ]];then
            echo -e "$rColor*******************************************$eColor"
            echo -e "$twinkleColor*****************Welcome!!!****************$eColor"
            echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
            echo -e "$rColor**   请选择需要使用的功能(输入编号)       **$eColor"
            echo -e "$rColor**   1:查看网卡信息                      **$eColor"
            echo -e "$rColor**   2:修改网卡(修改网卡为静态IP)         **$eColor"
            echo -e "$rColor**   3:修改网卡(修改网卡为动态IP)         **$eColor"
            echo -e "$rColor**   4:测试网络连通性和带宽                **$eColor"
            echo -e "$rColor**   5:修改网卡名称为eth0                  **$eColor"
            echo -e "$rColor**   6:README[使用前必读]                  **$eColor"
            echo -e "$rColor**   q:退出                              **$eColor"
            echo -e "$rColor**+++++++++++++++++++++++++++++++++++++++**$eColor"
            echo -e "$rColor*******************************************$eColor"
            read aNum
            case $aNum in
                1)  echo -e "$rTwoColor 您选择了 1$eColor"
                    funIPInformation
                ;;
                2)  echo -e "$rTwoColor 您选择了 2$eColor"
                    funModifyStaticIP
                ;;
                3)  echo -e "$rTwoColor 您选择了 3$eColor"
                    funModifyDynamicIP
                ;;
                4)  echo -e "$rTwoColor 您选择了 4$eColor"
                    funSpeedTest
                ;;
                5)  echo -e "$rTwoColor 您选择了 5$eColor"
                    funEth0
                ;;
                6)  echo -e "$rTwoColor 您选择了 6$eColor"
                    funREADME
                ;;
                q)  echo -e "$rTwoColor 再见！$eColor"
                    break
                ;;
            esac
        else
            echo -e "$twinkleColor 您没有开启网卡或网卡启动失败,是否重新开启?(y/yes开启)$eColor"
            read rStart
            if [[ $rStart == "y" || $rStart == "yes" ]];then 
                systemctl start network  &> /dev/null
                systemctl status network &> /dev/null
                if [[ $? -eq 0 ]];then
                    echo -e "$rTwoColor 网卡开启成功!$eColor"
                    continue
                else
                    echo -e "$rTwoColor 网卡开启失败!$eColor"
                    echo -e "$rTwoColor 网卡开启失败状态日志保存在当前目录:network-fail.log$eColor"
                    systemctl status network > network-fail.log 
                    break
                fi
            else 
                echo -e "$rTwoColor 再见！$eColor"
                break
            fi
        fi
    done
}
