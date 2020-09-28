#!/bin/bash
# create Joker
# time 5/18
# 
#DESCRIBE:一个函数库
#FUNCTION:1.cecho:输出颜色	2.YUM：安装软件	3.MKDIR：创建目录	4.CA_SERVICE:验证服务	5.CA_USER：验证用户
#	    6.CA_TAR:解包		7.JINDU:显示进度条	8.STR_SVC:启服务且开机自启		9.OK:正确	10.ERROR:错误
#		11.YUMMUL:安装多个软件包 12.Alert：调试程序  13.APT：安装单个软件  14.Apt_Mul:ubuntu安装多个包
#       15.CONFIG_IP_UBUNTU:配置静态IP 16.Check_Os:检测操作系统  17.Check_Hardware：检测硬件 18.Security_Conf：关闭防火墙，禁用selinux
#       19.CONFIG_IP_REDHAT:配置静态IP 20.DOCKER_INSECURE:配置docker信任私有仓库 21.CONFIG_IP_SUSE

#输出不同颜色的字体
#$1代表颜色编号,$2代表输出内容
cecho(){
	echo -e "\033[$1m$2\033[0m"
}

#安装多个软件
YUMMUL(){
	Array=$1
	for i in ${Array[*]}
	do
		rpm -q $i &> /dev/null
		if [ $? -ne 0 ];then
			echo -en "Installing $i......\t\t\t\t"
			yum -y install $i &> /dev/null	
			echo -e "\e[32;1m[OK]\e[0m"	
		fi
		rpm -q $i &> /dev/null
		[ $? -ne 0 ] && cecho 31 "$i安装错误" && exit $INSERROR
	done
}

#安装单个软件
YUM(){
	rpm -q $1 &> /dev/null
	if [ $? -ne 0 ];then
		echo -en "Installing $1......\t\t"
		yum -y install $1 &> /dev/null	
		echo -e "\e[32;1m[OK]\e[0m"	
	fi
	rpm -q $1 &> /dev/null
	[ $? -ne 0 ] && cecho 31 "$1安装错误" && exit $INSERROR
}

#创建目录,先检测目录是否存在
MKDIR(){
    if [ ! -d "$1" ];then
        mkdir -p "$1"
    else
        cecho 31 "$1已存在"		#红色
		exit 71
#   read -p "重新输入目录名:" DIR
#   MKDIR $DIR
    fi
}

#检测并创建文件
TOUCH(){
        if [ ! -f "$1" ];then
          	   touch $1
        else
                cecho 31 "$1已存在" &&  exit $ISERROR		#红色		    
        fi
}

OK(){
	Date=`date "+%F %R"`
	cecho 36 "$$: $Date $HOSTNAME $1 complecte OK!!!"
}
ERROR(){
	Date=`date "+%F %R"`
	cecho 31 "$$: $Date $HOSTNAME $1 It's A Wrong!!!"
}

#验证服务是否开启
CA_SERVICE(){
	ss -nutlp |grep $1 &> /dev/null
	if [ $? -eq 0 ];then
		OK $1
	else
		ERROR $1
		exit $INSERROR
	fi
}

#验证用户是否存在
CA_USER(){
	id $1 &> /dev/null
	[ $? -ne 0 ] && useradd -s /sbin/nologin $1 
}

#验证解压
CA_TAR(){
	if [ -f "$1" ];then
		echo -en "\e[34m正在解压$1......\e[0m\t\t"
		tar -xf $1 -C /opt
		echo -e "\e[32;1m[OK]\e[0m"
	else
		cecho 31 "$1不存在"
		exit $NOEXIST
	fi
}

JINDU(){
#trap 'kill $!' INT
	while :
	do
		echo -n '#'
		sleep 0.2
	done
}

#服务开机自启
STR_SVC(){
	ss -nutlp |grep $1 &> /dev/null
	[ $? -ne 0 ] && systemctl start $1 && systemctl enable $1 
}

#调试程序
#DISCRIPTION:设置debug值且范围为1-9开启调试；step=1为出现错误被挂起；step=2为每次调用函数后都会被挂起
Alert(){    
    local ret_code=$?
    debug=1
    step=0
    if [ -z "${debug}" ] || [ "${debug}" -eq 0 ];then
        return
    fi
    if [ "${ret_code}" -ne 0 ];then
        cecho 31 "Warn:$* failed return ${ret_code}" >&2
        [ "${debug}" -gt 9 ] && exit "${ret_code}"
        [ "${step}" -eq 1 ] && {
            echo "Press [Enter] to continue" >&2;read x
        }
    else
        cecho 96 "############ $* excute is success..."
    fi
    [ "${step}" -eq 2 ] && {
        echo "Press [Enter] to continue" >&2;read x
    }
}

#ubuntu安装单个软件
APT(){
    dpkg -s $1 &> /dev/null
	if [ $? -ne 0 ];then
		echo -en "Installing $1......\t\t"
		sudo apt-get -y install $1 --allow-unauthenticated &>/dev/null	
		echo -e "\e[32;1m[OK]\e[0m"	
	fi
	dpkg -s $1 &> /dev/null
	[ $? -ne 0 ] && cecho 31 "$1安装错误" && exit 71
}

#ubuntu安装多个包
Apt_Mul(){
	Array=$1
	for i in ${Array[*]}
	do		
		if ! dpkg -s $i &> /dev/null;then
			echo -en "Installing $i......\t\t\t\t"
			sudo apt-get -y install $i --allow-unauthenticated &> /dev/null	
			echo -e "\e[32;1m[OK]\e[0m"	
		fi		
		if ! dpkg -s $i &> /dev/null;then
            cecho 31 "$i安装错误" && sleep 600 && exit 71
        fi    
	done
}
#kit_pkgs1=(gcc build-essential python-dev unzip lib32stdc++6 lib32z1 gnupg zip lrzsz)
#Apt_Mul "${kit_pkgs1[*]}"

#设置静态IP(ubutnu16)
CONFIG_IP_UBUNTU(){
    echo "############ Config_Ip..."
    IP=`ip addr |awk '/inet /' |sed -n '2p' |awk -F' ' '{print $2}' |awk -F'/' '{print $1}'`
    MASK=`ifconfig  | sed -n 2p | awk -F ':' '{print $4}'`
    GATEWAY=`route | grep 'default' | awk '{print $2}'`
    INNETO=`ip addr  | awk  -F '^2:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`    
    INNETW=`ip addr  | awk  -F '^3:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
if ! egrep '\bstatic\b' /etc/network/interfaces &>/dev/null;then
    cp /etc/network/interfaces /etc/network/interfaces-backup
    cat >/etc/network/interfaces<<EOF
auto lo
iface lo inet loopback

auto $INNETO
iface $INNETO  inet static
address $IP 
netmask 255.255.255.0
gateway $GATEWAY
dns-nameservers 223.5.5.5
EOF
    if [ ! -z $INNETW ];then
    cat >> /etc/network/interfaces <<EOF
auto $INNETW
iface $INNETW  inet static
address 192.168.253.1
netmask 255.255.255.0
EOF
    fi
else
    if [ ! -z $INNETW ];then
        if ! grep "$INNETW" /etc/network/interfaces &>/dev/null;then
        cat >> /etc/network/interfaces <<EOF
auto $INNETW
iface $INNETW  inet static
address 192.168.253.1
netmask 255.255.255.0
EOF
        fi
    fi
  echo "already config static IP"
fi
}

#检测操作系统
Check_Os() {
    local os_flag=false
    if [ -e /etc/redhat-release ]; then
        os_flag=true
        os_version=$(cat /etc/redhat-release)
        cecho 92 "操作系统为: ${os_version}"
    fi

    if [ "${os_flag}" == "false" ] && [ -e /etc/issue ]; then
        if [ `grep -i 'Ubuntu' /etc/issue|wc -l` == '1' ]; then
            os_flag=true
            os_name=$(cat /etc/os-release |grep "^NAME" |awk -F'"' '{print $2}')
            os_version=$(cat /etc/os-release |grep "^VERSION=" |awk -F'"' '{print $2}')
            cecho 92 "操作系统为: ${os_name} ${os_version}"
        fi
    fi

    if [ "${os_flag}" == "false" ] && [ -e /etc/issue ]; then
        suse_flag=`cat /etc/issue | grep 'SUSE Linux Enterprise Server 12 SP3'|wc -l`
        if [ "${suse_flag}" == "1" ]; then
            os_flag=true
            os_name="suse12"
            cecho 92 "操作系统为: SUSE12 SP3"
        fi
    fi
}

#检测硬件
Check_Hardware(){
    cpu_core=$(lscpu |grep "^Core(s)" |awk -F':    '  '{print $2}')
    cpu_thread=$(lscpu |grep "^Thread(s)" |awk -F':    '  '{print $2}')
    cecho 92 "cpu为：${cpu_core}核${cpu_thread}线程"
    memery_all=$(free -m | awk 'NR==2' | awk '{print $2}')
    cecho 92 "内存为${memery_all}M"
    disk_unit=$(lsblk |egrep '^(v|s)d[a-z]' |awk '{print $4}' |sed -n '1p' |sed 's/\(.*\)\(.\)$/\2/')
    disk_space=$(lsblk |egrep '^(v|s)d[a-z]' |awk '{print $4}'|sed 's/[a-Z]//'|awk '{disk[$1]++} END {for(i in disk){print i}}' |awk '{sum +=$1};END{print sum}')
    cecho 92 "磁盘总空间为${disk_space}${disk_unit}"
}

#关闭防火墙，禁用selinux
Security_Conf(){
   systemctl disable firewalld  &>/dev/null
   systemctl stop firewalld &>/dev/null
   local selinux_mode=$(grep '^SELINUX=' /etc/selinux/config |awk -F'=' '{print $2}')
   if [ ${selinux_mode} != "disabled" ];then
      setenforce 0
      sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config
      cecho 92 "selinux需重启系统才能生效"
   fi
}

#配置静态IP(RedHat7)
CONFIG_IP_REDHAT(){
    echo "############ Config_Ip..."
    #提取IP地址和网关
    IP=`ip addr |awk '/inet /' |sed -n '2p' |awk -F' ' '{print $2}' |awk -F'/' '{print $1}'`
    #MASK=`ifconfig |grep 'inet '|grep -v '127.0.0.1'|awk '{print $4}'`
    GATEWAY=`route -n |sed -n '3p'|awk '{print $2}'`
    INNETO=`ip addr  | awk  -F '^2:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`    
    INNETW=`ip addr  | awk  -F '^3:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
    local eth_conf=/etc/sysconfig/network-scripts/ifcfg-${INNETO}
    if grep "dhcp" ${eth_conf} &>/dev/null;then
        [ ! -f ${eth_conf}.bak ] && cp ${eth_conf}{,.bak}        
        sed -i '/BOOTPROTO/ s/dhcp/static/' ${eth_conf}
        sed -i "/BOOTPROTO/a GATEWAY=${GATEWAY}" ${eth_conf}
        sed -i "/BOOTPROTO/a NETMASK=255.255.255.0" ${eth_conf}
        sed -i "/BOOTPROTO/a IPADDR=${IP}" ${eth_conf}
        local boot_value=$(grep '^ONBOOT' ${eth_conf} |awk -F'"' '{print $2}')
        if [ ${boot_value} != "yes" ];then
            sed -i '/ONBOOT/s /no/yes/' ${eth_conf}
        fi
    else
      echo "already config static IP"
    fi
}

#配置docker信任私有仓库
DOCKER_INSECURE(){
    repository_ip=192.168.138.182
    repository_port=8029
    local user=qixiang.an
    local pwd=1Qaz@123
    tee /etc/docker/daemon.json << EOF
{
    "insecure-registries": ["${repository_ip}:${repository_port}"]
}
EOF
systemctl restart docker
    docker login http://${repository_ip}:${repository_port} -u ${user} -p ${pwd} &>/dev/null
    [ "$?" -ne 0 ] && cecho 31 "docker登陆失败" && exit 71
    return 0
}

#配置静态IP(SUSE12)
CONFIG_IP_SUSE(){
    echo "############ Config_Ip..."
    #提取IP地址和网关
    IP=`ip addr |awk '/inet /' |sed -n '2p' |awk -F' ' '{print $2}' |awk -F'/' '{print $1}'`
    #MASK=`ifconfig |grep 'inet '|grep -v '127.0.0.1'|awk '{print $4}'`
    GATEWAY=`route -n |sed -n '3p'|awk '{print $2}'`
    INNETO=`ip addr  | awk  -F '^2:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
    INNETW=`ip addr  | awk  -F '^3:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
    local eth_conf=/etc/sysconfig/network/ifcfg-${INNETO}
    if grep "dhcp" ${eth_conf} &>/dev/null;then
        [ ! -f ${eth_conf}.bak ] && cp ${eth_conf}{,.bak}
        cat > ${eth_conf} << EOF
BOOTPROTO='static'
IPADDR=${IP}
NETMASK=255.255.255.0
STARTMODE='auto'
EOF
        [ ! -f /etc/sysconfig/network/routes.bak ] && cp /etc/sysconfig/network/routes{,.bak}
        echo "default ${GATEWAY}" > /etc/sysconfig/network/routes
    else
      echo "already config static IP"
    fi
}
  
