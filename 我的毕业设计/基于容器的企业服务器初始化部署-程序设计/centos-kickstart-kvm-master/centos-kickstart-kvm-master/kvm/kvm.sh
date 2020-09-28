#/bin/bash

#=================================================#
#    kvm  install 名称 ==> 创建新的KVM
#    kvm  delete  名称 ==> 删除指定KVM
#    kvm  ip      名称 ==> 查看对应的IP
#    kvm  start   名称 ==> 启动KVM
#    kvm  check   名称 ==> 检查KVM
#    kvm  restart 名称 ==> 重启KVM
#=================================================#


DISKPATH="/opt/kvm/disk"
ISOPATH="/opt/kvm/iso/centos.iso"

###_____KVM管理相关______###

#检查KVM状态
function checkKvm(){
    STATUS=`virsh  list --all | grep  -e  $1`
    if [ -z "$STATUS" ];then
        echo "虚拟机不存在"
        exit 1
    fi
}

#启动KVM
function startKvm(){
    checkKvm $1
    if [ $? -eq 0 ]; then
        virsh  start $1
    fi
}


#启动所有关闭的kvm
function startAllKvm(){

	NOT_RUN_KVM=`virsh  list --all | grep  " - " | awk '{print $2}'`
	if [ -z "$NOT_RUN_KVM"  ]; then
			exit 0
	fi
	for i in $NOT_RUN_KVM
	do
        virsh  start $i
	done		
		
}

#重启KVM
function restartKvm(){
    checkKvm $1
    virsh  reboot $1
}

#关闭所有

function stopAllKvm(){
    RUN_KVM=` virsh   list  --all  | grep  "running" | awk '{print $2}'`
	if [ -z "$RUN_KVM" ];then
			exit 0
	fi
	for i in $RUN_KVM
	do
	    virsh shutdown $i
    done
}

#删除KVM

function destoryKvm(){
    virsh shutdown $1
    virsh destroy $1
    virsh undefine $1
    rm -f $DISKPATH/$1.qcow2
}

#获取KVM 的IP
function getKvmIp(){
    checkKvm $1
	RUNNING_KVM=`virsh  list --all | grep  $1`
	MAC=`virsh  dumpxml    $1 | grep "mac address" | awk -F"'" '{print $2}'` 
	IP=`arp -ne |grep "$MAC" |awk '{printf $1}'` 
	echo "$IP"
}

###____KVM安装相关______###

#检查目录是否存在
function checkAndmkDir(){
    if [ ! -d $DISKPATH ]; then
        mkdir -p $DISKPATH
    fi
}

#创建虚拟硬盘
function  createDisk(){
   checkAndmkDir
	qemu-img  create  -f qcow2 $DISKPATH/$1.qcow2 10G
	if [ -f $DISKPATH/$1.qcow2 ];then
		echo "Create Disk  $1.qcow2 SUCCESS !"
	fi
}


#安装系统
function installKvm(){
    echo "INSTALLING  $1"
	virt-install   --name $1  --ram 1024  --vcpus=1   --cdrom=$ISOPATH  --disk=$DISKPATH/$1.qcow2 --network network=default,model=virtio --os-type linux --os-variant rhel7.6
}





#第一个参数是功能参数

if [ -z $1 ];then
    echo "参数不合法"
elif [ "install" = $1 ];then
    createDisk $2
    if [ $? -eq 0 ]; then
        installKvm $2
    fi
elif [ "check" = $1 ];then
    checkKvm $2
elif [ "start" = $1 ];then
    startKvm $2
elif [ "restart" = $1 ];then
    restartKvm $2
elif [ "ip" = $1 ];then
    getKvmIp $2
elif [ "delete" = $1 ];then
    destoryKvm $2
elif [ "start-all" = $1 ];then
	startAllKvm
elif [ "stop-all" = $1 ];then
	stopAllKvm
else
    echo "命令不合法"
fi



