#!/bin/bash 2.0
##############################################################
#/bin/bash                Emai: jw468657802@163.com          #
#date: 2019/8/28 14:10    结篇行数：571行                    #
#Filename: strkvm         v2.0 更新至686行                   #
#Author: Jinshell                                                 #
##############################################################
kvm1="++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                                                                        +
+           + +   + +              + +          21.查看虚拟机            +
+          +   + +   +             + +          22.设置硬件CPU           +
+           +       +            +++++++        23.设置硬件内存          +
+             +   +                +++             版本日志              +
+               +                  +++                                   +
+     kvm管理器 v.0.10             +++                                   +
+     1.创建虚拟机                 +++                                   +
+     2.启动虚拟机                  +                                    +
+     3.删除虚拟机                                                       +
+     4.添加硬盘                                                         +
+     5.添加网卡                                                         +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                      6.【设置主机名与IP】                              +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+       &&$                                                              +
+      &&&$&                                                             +
+    $&&&&&&&&                                                           +
+     $&&&&&                                                             +
+      $&&&                                                              +
+       &&                        7.关闭虚拟机                           +
+       &&                        8.帮助 或 h键                          +
+       &&                        9.退出 或 q键                          +
+       &&                     888.全新机器必选项                        +
+       &&                                                               + 
+       &&                                                               +
+       &&                                                               +
+       &&                                                               +
+                                                                        +
+                                                                        +
+                                                                        +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
kvm2="&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
^                                                                                         ^
^       1.自定义创建虚拟机 #不推荐使用此项                                                ^
^       2.快速创建虚拟机                                                                  ^
^       3.上一层菜单                                                                      ^
^                                                                                         ^
^  # 注，此项位新机选择项，安装时间较长，因为是安装一个全新的Linux系统，不是克隆链接等    ^
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

helpk="====================================================================================
                                                                              ^
  1.创建虚拟机，#选项的功能为克隆你的一个模板机，快速生成一个新的虚拟机，占内存小，缺点不能删除模板机
  2.启动虚拟机，#选项的子功能为；1.查看启动的虚拟机||2.所有虚拟机||3.启动单台虚拟机||4.启动一组
  3.3.删除虚拟机，#选项的子功能为：1.查看所有虚拟机||2.删除单台虚拟机||3.删除一组||4.上一层
  4.4.添加硬盘， #选项的子功能为：1.查看所有虚拟机||2.添加临时硬盘||3.添加永久硬盘||4.上一层||输入你的选择||
  5.添加网卡， #选项的子功能为：1.查看所有虚拟机||2.添加网卡||3.上一层||输入你的选择||
  6.设置主机名与IP，#选项的子功能为：1.查看状态||2.设置单个虚拟机||3.设置一组虚拟机||4.上一层||
  7.关闭虚拟机，#选项的子功能为：1.查看所有虚拟机||2.关闭单台虚拟机||3.关闭一组虚拟机||4.关闭所有虚拟机||5.上一层
  8.帮助，#即为该选项
  9.退出，#即为退出该脚本
  888.全新机器必选项，#选项子功能为：1.自定义创建虚拟机||2.快速创建虚拟机
  ###此项位新机选择项，安装时间较长，因为是安装一个全新的Linux系统，不是克隆链接等"

newkvm(){
clear
while true
do
    virsh list --all    
    read -p "$kvm2" createhost
    case $createhost in
    1)
        echo "休息一下。。。"
        yum groupinstall "Virtualization Client" "Virtualization Hypervisor" "Virtualization Platform" "Virtualization Tools" &> /dev/null
        systemctl start libvirtd
        echo "如果你是第一次使用，可以在浏览器打开下面的教程链接"
        echo "https://blog.csdn.net/qq_41847721/article/details/100184373"
        sleep 5
        read -p "输入要创建的虚拟机名||" kvname
        read -p "输入要创建的虚拟机CPU核数||输入为正整数" vvcpu
        read -p "输入要创建的虚拟机内存【单位GB】||输入为正整数：" agbd
        agbb=`echo $(($agbd*1024))`
        read -p "输入要创建的虚拟机镜像位置格式：/root/aa/centos***.iso||" iios
        #read -p "输入创建虚拟机的存放路径-格式：/root/aa/||" kpath
        read -p "输入要创建的虚拟机硬盘大小||" ssimg
        #echo "默认虚拟机存放路径为/home/kvm/请不要更改，否则后续无法继续使用"
        echo "创建中... ... ..."
        cat <<-EOF >> /etc/libvirt/qemu.conf
	user = "root"
	group = "root"
	dynamic_ownership = 0
	EOF
        service libvirtd restart
        mkdir /home/kvm >& /dev/null
        virt-install --name $kvname --ram $agbb --vcpus $vvcpu --location=$iios --disk path=/home/kvm/$kvname.img,size=$ssimg --graphics none --network bridge=virbr0  --extra-args "console=ttyS0"
    
    ;;
    2)
      echo "休息一下。。。"
      sleep 1
      yum groupinstall "Virtualization Client" "Virtualization Hypervisor" "Virtualization Platform" "Virtualization Tools" &> /dev/null    
      systemctl start libvirtd
      echo "如果你是第一次使用，可以在浏览器打开下面的教程"
      echo "https://blog.csdn.net/qq_41847721/article/details/100184373"
      sleep 5
      read -p "输入要创建的虚拟机名" kvname
      #virsh list --all |awk '/[0-9]/{print $2}' | awk -F - '{print $1}' > 2.txt
      # for i in `cat 1.txt`;do
      virsh list --all | awk '/'$kvname'/{print $2}' > 2.txt
      k_vname=`grep $kvname 2.txt`
           if [ "$k_vname" == $kvname ];then
           echo  ============================
           echo "======主机名已被使用========"      
           echo  ============================
           break
           fi
                 explain="输入要创建的虚拟机镜像位置格式：/root/aa/centos***.iso ||2.前面的镜像要写绝对路径："
                 read -p "$explain" iios
                 cat <<-EOF >> /etc/libvirt/qemu.conf
                user = "root"
                group = "root"
                dynamic_ownership = 0
			EOF
            service libvirtd restart                  

            touch a-log.txt b-log.txt &> /dev/null
            mkdir /home/kvm &> /dev/null
            virt-install --name $kvname --ram 1024 --vcpus 1 --location=$iios --disk path=/home/kvm/$kvname.qcow2,size=5 --graphics none --network bridge=virbr0  --extra-args "console=ttyS0"


    ;;
    *)
        break
    ;;
    esac
done
}

createkvm(){
clear
while true
do
    virsh list --all
    read -p "1.创建单个||2.创建一组||3.返回上一层" creategroup
    if [ $creategroup -eq 1 ] ; then
    read -p "创建虚拟机的名字: " host_name
    #hostname=`virsh list --all |awk '/[0-9]/{print $2}' | awk -F - '{print $1}' > 1.txt`
    virsh list --all |awk '/[0-9]/{print $2}' | awk -F - '{print $1}' > 1.txt
    for i in `cat 1.txt`;do
         if [ "$i" == "$host_name" ] ; then
            echo $i
            echo "============================"
            echo "======主机名已被使用========"
            echo "============================"        
            break ; break
         fi
    done
            read -p "请输入一个已存在的模板主机名：" h_ostname
            mkdir /home/kvm &> /dev/null
            echo "$h_ostname"
            eval qemu-img create -f qcow2 -b /home/kvm/${h_ostname}.qcow2 /home/kvm/${host_name}.qcow2
            eval /bin/cp -f /etc/libvirt/qemu/${h_ostname}.xml /etc/libvirt/qemu/${host_name}.xml
            sed -i "/$h_ostname/s//$host_name/" /etc/libvirt/qemu/${host_name}.xml
            sed -i '/<uuid>/d' /etc/libvirt/qemu/${host_name}.xml
            sed -i '/<mac address/d' /etc/libvirt/qemu/${host_name}.xml
            sed -i '/'source'/s/'${h_ostname}.qcow2'/'${host_name}.qcow2'/' /etc/libvirt/qemu/${host_name}.xml
            virsh define /etc/libvirt/qemu/${host_name}.xml
            echo "虚拟机已创建"
        
    elif [ $creategroup -eq 2 ] ; then
       read -p "请输入您想创建的虚拟机个数" num1
       read -p "创建虚拟机的名字: " host_name
       virsh list --all |awk '/[0-9]/{print $2}' | awk -F - '{print $1}' > 1.txt
       for i in `cat 1.txt`;do
           if [ "$i" == $host_name ];then
           echo $i
           echo  ============================
           echo "======主机名已被使用========"      
           echo  ============================
           break                   
           fi
           done
       		#read -p "创建虚拟机的名字: " host_name
       		read -p "请输入一个已存在的模板主机名：" h_ostname
       		for((n=1;n<=$num1;n++))
       		do
       		       local name=${host_name}-${n}
       		       eval qemu-img create -f qcow2 -b /home/kvm/${h_ostname}.qcow2 /home/kvm/${name}.qcow2 &> /dev/null 
       		       eval /bin/cp -f /etc/libvirt/qemu/${h_ostname}.xml /etc/libvirt/qemu/${name}.xml &> /dev/null          
       		       sed -i "/$h_ostname/s//$name/" /etc/libvirt/qemu/${name}.xml &>/dev/null
       		       sed -i '/<uuid>/d' /etc/libvirt/qemu/${name}.xml &> /dev/null
       		       sed -i '/<mac address/d' /etc/libvirt/qemu/${name}.xml &> /dev/null
       		       sed -i '/'source'/s/'${h_ostname}.qcow2'/'${name}.qcow2'/' /etc/libvirt/qemu/${name}-$i.xml &> /dev/null
       		       virsh define /etc/libvirt/qemu/${name}.xml &> /dev/null
       		                                  
       		done                          
       		echo "虚拟机已创建完成"
    elif [ $creategroup -eq 3 ] ; then
        break
    fi
done
}
catkvm(){
     clear
     virsh list --all
     sleep 3
}

startkvm(){
clear
virsh list --all
sunm1="1.查看启动的虚拟机||2.所有虚拟机||3.启动单台虚拟机||4.启动一组||5.上一层"
while true
do
     #   clear
     #virsh list --all
     read -p "$sunm1" sunm2
     case $sunm2 in
     1)
         virsh list
     ;;
     2)
         virsh list --all
     ;;
     3)
         read -p "输入要启动虚拟机名称" startkvm1
         #startkvm2=` virsh list --all |awk '/'$startkvm1'/{print $2}'`
         virsh start $startkvm1
     ;;
     4)
        virsh list --all
        echo "通组开启仅适用与通组创建"
                read -p "请输入您想关闭的这组虚拟机名称的前缀[只能是字母]: " your_name
                sum1=`virsh list --all | awk '/[0-9]/{print $2}' | grep $your_name | wc -l`
                for i in `seq $sum1`;do
                        virsh start $your_name-$i
                done
                echo "一组虚拟机已经成功启动!"
     ;;
     *)
         break
     ;;
     esac
done
}

deletekvm(){
sunm3="1.查看所有虚拟机||2.删除单台虚拟机||3.删除一组||4.上一层"
clear
while true
do 
   
   virsh list --all
   read -p "$sunm3" sunnm4 
   case $sunnm4 in
   1)
       virsh list --all
   ;;
   2)
       read -p "输入要删除虚拟机主机" deletekvm1
       stdelete=`virsh list --all | grep $deletekvm1 |awk -v akv=$deletekvm1 '{if($2==akv)print $3}'`
       if [ $stdelete != "running" ] ; then
           deletekvm2=`virsh list --all | grep $deletekvm1 |awk -v akv=$deletekvm1 '{if($2==akv)print $2}'`
           virsh undefine $deletekvm2
           rm -rf /home/kvm/${deletekvm2}.qcow2        
           rm -rf /etc/libvirt/qemu/${deletekvm2}.xml
           echo "删除成功！！！！！！！！！！！！！！！！！！！！！"
       else
           echo "请先将虚拟机关机！！！！！！！！！！！！！！！！！！！！"
       fi
   ;;
   3)
       echo "通组删除仅适用与通组创建"
       virsh list --all
                read -p "请输入您想删除的这组虚拟机名称的前缀[只能是字母]: " your_name
                sum=`virsh list --all | awk '/[0-9]/{print $2}' | grep $your_name | wc -l`
                for i in `seq $sum`;do
                        virsh undefine $your_name-$i.qcow2
                        rm -rf /home/kvm/$your_name-$i.qcow2
                        rm -rf /etc/libvirt/qemu/$your_name-$i.xml
                done
                echo "一组虚拟机已经成功删除!"
   ;;
   *)
       break
   ;;
   esac
done
}
addsdkvm(){
sunm4="1.查看所有虚拟机||2.添加临时硬盘||3.添加永久硬盘||4.上一层||输入你的选择||"
clear
while true
do
   virsh list --all
   echo "添加硬盘必需在虚拟机开机状态下进行，不然会报错！！！"
   read -p "$sunm4" sunnm5
   case $sunnm5 in
   1)virsh list --all;;
   2)
       clear
       virsh list --all
        
       read -p "输入要添加硬盘虚拟机的ID" startkvm3
       read -p "输入要添加硬盘虚拟机名称" startkvm3
       startkvm2=`virsh list --all |awk '/'$startkvm3'/{print $2}'`
       virsh list --all | awk '/'$startkvm3'/{print $2}' > 1.txt
       runni=`virsh list --all | awk '/'$startkvm3'/{print $3}'`
       ame_host=`grep $startkvm2 1.txt`
       if [ $startkvm2 == $ame_host ] ; then
           if [ $runni == "running" ] ; then
                   for i in a b c d e f g h i j k l m n o p q r s t o v w x y z;do
                       virsh domblklist $startkvm2 | grep vd$i > /dev/null
                       if [ $? -ne 0 ] ; then
                       echo $i 
                              read -p "请输入您想添加的磁盘大小[只能是整数，默认单位为GB]:" asize
                              qemu-img create -f qcow2 /home/kvm/${startkvm2}-$i.img ${asize}G >/dev/null 
                              virsh attach-disk $startkvm2 /home/kvm/${startkvm2}-$i.img vd$i > /dev/null
 #--cache writeback --subdriver qcow2 --persistent
                              echo "磁盘添加成功！！"
                              sleep 3
                              echo "如果未设置成功，请先到虚拟机内使用【fdisk -l】查看，或重新添加"
                              break                         
                       fi     
                   done               
           else
               echo "主机必需在运行【running】状态"
           fi
               
       else 
           echo "主机不存在"        
       fi
          
   ;;
   3)
      echo "||待开发。。。。。。||"
      sleep 3
   ;;
   *)
    break
   ;;   

   esac
done
}
addifcfig(){
sunma1="1.查看所有虚拟机||2.添加网卡||3.上一层||输入你的选择||"
clear
while true
do
    virsh list --all
    echo "添加网卡必需在虚拟机开机状态下进行，不然会报错！！！"
    read -p "$sunma1" sunma2
    case $sunma2 in
    1)virsh list --all;;
    2)
    read -p "请输入您想添加网卡的虚拟机的ID: " s_tartkvm
    read -p "请输入您想添加网卡的虚拟机名" startk_vm
    startkv_m=` virsh list --all |awk '/'$s_tartkvm'/{print $2}'`
    if [ $startk_vm == $startkv_m ] ; then
        virsh attach-interface $s_tartkvm --type bridge --source virbr0 --persistent
        if [ $? -eq 0 ] ; then
              echo "网卡添加成功！！"
        else
              echo "您的网卡好像没有添加成功哟！！"
        fi
    else
         echo "您输入的主机名不存在！！"
    fi

    ;;
    *)
    break
    ;;
    esac
done
}
stopkvm(){
sunam3="1.查看所有虚拟机||2.关闭单台虚拟机||3.关闭一组虚拟机||4.关闭所有虚拟机||5.上一层"
clear
virsh list --all
while true
do
    read -p "$sunam3" sunam4
    case $sunam4 in
    1)virsh list --all;;
    2)read -p "输入要关闭虚拟机的ID" startkv1m
         startkv2m=` virsh list --all |awk '/'$startkv1m'/{print $2}'`
         virsh list --all | awk '{print $2}' > 1.txt
         com_name=`grep $startkv2m 1.txt`
         if [ "$com_name" == $startkv2m ] ; then
                virsh destroy $startkv2m
                echo "您的虚拟机已经关闭！！"
         else
                echo "输入错误！！"
         fi


    ;;
    3)
        virsh list --all
                read -p "请输入您想关闭的这组虚拟机名称的前缀[只能是字母]: " your_name
                sum=`virsh list --all | awk '/[0-9]/{print $2}' | grep $your_name | wc -l`
                for i in `seq $sum`;do
                        virsh destroy $your_name-$i &> /dev/null
                done
                echo "一组虚拟机已经成功关闭!"
    ;;


    4)
         for i in `virsh list --all |awk '/[0-9]/{print $2}'`;do
                        virsh destroy $i
                done
                        echo "您的虚拟机已经全部关闭！"

    ;;
    *)
        break
    ;;
    esac
done
}
ipactive(){
clear
echo "请在关机状态下进行，不然出错自负！！"
action1="1.查看状态||2.设置单个虚拟机||3.设置一组虚拟机||4.上一层||"
while true
do  
    read -p "$action1" action2
    case $action2 in
    1)virsh list --all;;
    2)
         clear
         virsh list --all
         echo "请在关机状态下进行，不然出错自负！！"
         read -p "请输入您想设置的虚拟机名称: " host_action
         virsh list --all | awk '/[0-9]/{print $2}' > 1.txt
         name_host=`grep $host_action 1.txt`
         if [ "$name_host" == $host_action ] ; then
               read -p "请输入您想设置的ip： " ip
               read -p "请输入您想设置的主机名： " host6
               read -p "确认你输入的是否正确[yes] " sure
               gateway=`echo $ip | awk -F \. '{print $1"."$2"."$3}'`
               if [ "$sure" == "yes" ];then
                        cd
                        virsh destroy $host_action &>/dev/null
                        umount /mnt &> /dev/null
                        rm -rf /mnt/*
                        ifcfg=/mnt/etc/sysconfig/network-scripts/ifcfg-eth0
                        guestmount -a /home/kvm/${host_action}.qcow2 -i /mnt/
                                cat <<-EOF > /mnt/etc/sysconfig/network-scripts/ifcfg-eth0
                                NAME=eth0
                                DEVICE=eth0
                                BOOTPROTO=none
                                ONBOOT=yes
                                IPADDR=$ip
                                GATEWAY=$gateway.1
                                PREFIX=24
				EOF
                        sed -i 's/^ *//g' $ifcfg
                        sed -i 's/\t//g' $ifcfg
                        echo $host6 > /mnt/etc/hostname
                        echo $ip $host6 >> /mnt/etc/hosts
                        umount /mnt
                        virsh start $host_action
                        echo 任务完成！
               else
                     echo "请确认正确！！"
                  
               fi
         else
            echo "虚拟机不存在！！"
           
         fi


    ;;
    3)
        virsh list --all
                rm -rf /tmp/*
                echo "请在关机状态下进行，不然出错自负！！"
                read -p "请输入您想设置的一组虚拟名称的前缀[只能是前面的英文字母]: " h_action
                read -p "请输入您想设置的起始ip： " ip
                gateway=`echo $ip | awk -F \. '{print $1"."$2"."$3}'`
                next_ip=`echo $ip | awk -F \. '{print $4}'`
                num=`virsh list --all | awk '/[0-9]/{print $2}' | grep $h_action | wc -l`
                for i in `seq $num`;do
                        read -p "请输入您想设置的第$i个主机名： " hostname1
                        echo "$gateway.$next_ip $hostname1" >> /tmp/hosts.txt
                        let next_ip=next_ip+1
                done
                echo "Please wait a minute..............................."
                cd
                for i in `seq $num`;do
                        virsh destroy $h_action-$i &>/dev/null
                        umount /mnt &> /dev/null
                        if [ ! -z /mnt ];then
                                ifcfg=/mnt/etc/sysconfig/network-scripts/ifcfg-eth0
                                guestmount -a /home/kvm/$h_action-$i.qcow2 -i /mnt/
                                cat <<-EOF > /mnt/etc/sysconfig/network-scripts/ifcfg-eth0
                                NAME=eth0
                                DEVICE=eth0
                                BOOTPROTO=none
                                ONBOOT=yes
                                IPADDR=`head -$i /tmp/hosts.txt | tail -1 | awk '{print $1}'`
                                GATEWAY=$gateway.1
                                PREFIX=24
				EOF
                                sed -i 's/^ *//g' $ifcfg
                                sed -i 's/\t//g' $ifcfg
                                head -$i /tmp/hosts.txt | tail -1 | awk '{print $2}' > /mnt/etc/hostname                
                                cat /tmp/hosts.txt >> /mnt/etc/hosts
                                echo nameserver 8.8.8.8 >> /mnt/etc/resolv.conf
                                umount /mnt
                        else
                                echo 您的镜像没有依次进行挂载卸载,请检查！
                                exit
                        fi
                done
                echo "设置完成!"
    ;;
    *)
       break
    ;;
    esac
done

}

helpkvm(){
clear
while true
do
    #virsh list --all
    read -p "||1.查看所有帮助||h.查看帮助||q.上一层||" iii
    case $iii in
    1)
       echo "$helpk"
       sleep 5
    ;;
    2)
        echo "$helpk"
       sleep 2
    ;;
    q)
        break
    ;;
    h)
       echo "$helpk"
       sleep 3
     ;;
    *)
        break
    ;;
    esac
done
}
quitkvm(){
    exit
}
setkvm(){
clear
virsh list --all
setk1="1.查看状态||2.设置单个虚拟机cpu||3.设置一组虚拟机cpu||4.上一层||"
while true
do
    read -p "$setk1" setk2
    case $setk2 in
    1)
         read -p "输入要查看的虚拟机||" setk3
         virsh dominfo $setk3
    ;;
    2)
    read -p "输入要设置的虚拟机" setkvm1
    read -p "输入设置cpu核数||可以增加||可以减小||" cpu1
    setkvm2=`virsh list --all | grep $setkvm1 |awk -v akv=$setkvm1 '{if($2==akv)print $3}'`
    setkvm3=`virsh list --all | awk '/'$setkvm1'/{print $2}'`
    if [ $setkvm2 == "running" ] ; then
       echo "请先将虚拟机关机！！！！！！！！！！！！！！！！！！！！"
    elif [ $setkvm3 == $setkvm1 ] ; then
        virsh destroy $setkvm1
        setkvm4=`virsh dominfo $setkvm1 | awk -F " " '/CPU/{print $2}' |awk '/[0-9]/{print $0}'`        
        sed -i '/vcpu/s/'$setkvm4'/'$cpu1'/' /etc/libvirt/qemu/$setkvm1.xml
        virsh define /etc/libvirt/qemu/$setkvm1.xml
        virsh start $setkvm1
        echo "设置成功！！！！！！！！！！！！！！！！！！！！！"
    else
           echo "虚拟机不存在！！！！！！！！！！！！！！！！！！！！"
    fi
    ;;
    3)
        echo "待开发"
        sleep 5
    ;;
    *)break;;
    esac
done
}
memorykvm(){
clear
virsh list --all
memory1="1.查看状态||2.设置单个虚拟机内存||3.设置一组虚拟机内存||4.上一层||"
while true
do
    read -p "$memory1" memory2
    case $memory2 in
    1)
       read -p "输入要查看的虚拟机||" setk3
       virsh dominfo $setk3
    ;;
    2)
         read -p "输入要设置的虚拟机" memory4
         read -p "输入设置内存大小||可以增加||可以减小||【单位：GB】" memory5
         memo2=`virsh list --all | grep $memory4 |awk -v akv=$memory4 '{if($2==akv)print $3}'`
         setkvm3=`virsh list --all | awk '/'$memory4'/{print $2}'`
         if [ $memo2 == "running" ] ; then
            echo "请先将虚拟机关机！！！！！！！！！！！！！！！！！！！！"
         elif [ $setkvm3 == $memory4 ] ; then
             expr $memory5 + 0 &> /dev/null
             if [ $? -eq 0 ] ; then
                 virsh destroy $memory4
                 memory6=`cat /etc/libvirt/qemu/$memory4.xml |awk -F">" '/memory/{print $2}'|awk -F"<" '{print $1}'`                 memory7=`echo $(($memory5*1024*1024))`
                 sed -i '/memory/s/'$memory6'/'$memory7'/' /etc/libvirt/qemu/$memory4.xml
                 sed -i '/currentMemory/s/'$memory6'/'$memory7'/' /etc/libvirt/qemu/$memory4.xml                 
                 virsh define /etc/libvirt/qemu/$memory4.xml
                 virsh start $memory4
                 echo "设置成功，已自动启动，当前内存为$memory6！！！！！！！！！！！"
              else
                  echo "请以【GB】为单位，输入整数"
              fi
         else
                echo "虚拟机不存在！！！！！！！！！！！！！！！！！！！！"
         fi
    ;;
    3)
      echo =====
      sleep 3
    ;;
    *)
       break
     ;;
    esac
done
}
versionlog(){
clear
while true
do
    read -p "" version1
    case version1 in
    1)
       version1="1. V1.0版本脚本开发基本功能完毕
                 2. 增加了888选项，可以创建完整的虚拟机
                 3. 修复bug若干"
       echo "$version1"
       sleep 5
    ;;
    2)
        version2="1. V2.0版本更新了增加cpu和内存的功能
                 2. 888选项里增加可自定义内存和cpu的参数"
        echo "$version2"
        sleep 5  
 
      ;;

    *)break;;
    esac

done

}

while true
do 
    read -p "$kvm1" option1
    case $option1 in
    1)createkvm;;
    2)startkvm;;
    3)deletekvm;;
    4)addsdkvm;;
    5)addifcfig;;
    6)ipactive;;
    7)stopkvm;;
    8)helpkvm;;
    888)newkvm;;
    21)catkvm;;
    22)setkvm;;
    23)memorykvm;;
    111)versionlog;;
    9)quitkvm;;
    h)helpkvm;;
    q)quitkvm;;
    esac
done
