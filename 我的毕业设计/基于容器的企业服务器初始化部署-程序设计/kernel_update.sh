#!/bin/bash
# create Joker
# time 5/1
#
kernel_update(){
    #更新内核
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
    yum --enablerepo=elrepo-kernel install kernel-ml -y
    echo "GRUB_DEFAULT=0" >> /etc/default/grub && grub2-mkconfig -o /boot/grub2/grub.cfg
    if [ $? -eq 0 ];then
        echo "内核升级为最新稳定版本！重启后生效！"
    else
        echo "内核升级失败,检查网络后重试！"
        return 1
    fi
    #更新bash
    echo "正在更新bash....."
    wget http://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz
    tar zxvf bash-5.0.tar.gz
    cd bash-5.0
    ./configure && make && make install
    if [[ $? -eq 0 ]];then
        mv /bin/bash /bin/bash.bak
        ln -s /usr/local/bin/bash /bin/bash
        echo "bash更新成功！重启后生效！"
    else
        echo "bash更新失败！请检查gcc是否安装有问题！"
    fi
    cd ..
}