---
title: '[Kvm]Centos6自动安装镜像制作'
category: Linux
tag: Linux
date: 2019-01-01 00:00:00
---

制作自动化安装的 centos6 ISO镜像

# 前提以及注意事项

1. 操作环境是centos-6.10
2. 网络dhcp
3. 时区 Asia/Shanghai
4. 默认密码是:  sdfsdf
5. 基于 `CentOS-6.10-x86_64-minimal.iso` 制作(从官网或者国内镜像站下载)

# 环境准备

1. 安装工具
```bash
yum -y install anaconda repodata createrepo mkisofs rsync
```
2. 创建原挂载目录, 自定义ISO目录
```bash
mkdir -p  /mnt/cdrom  #原ISO挂载目录
mkdir -p  /data/ISO   #自定义修改ISO目录
```
3. 挂载原ISO文件
```bash
mount -o loop CentOS-6.10-x86_64-minimal.iso /mnt/cdrom
```
4. 拷贝原ISO文件内容到自定义目录
```bash
rsync -a --exclude=Packages/ /mnt/cdrom/ /data/ISO/
rm -rf /data/ISO/repodata
mkdir -p /data/ISO/{Packages,repodata}
```


# 开始制作

1. 拷贝软件包
```bash
#!/bin/bash 
cd /root
awk '/Installing/{print $2}' install.log | sed 's/^*://g' > package.txt 
PACKAGES='/mnt/cdrom/Packages'
PACKDIR='/root/package.txt'
NEW_PACKAGES='/data/ISO/Packages'
while read LINE 
do
cp ${PACKAGES}/${LINE}.rpm /${NEW_PACKAGES} || echo "$LINE don't cp......."
done < package.txt
rm -f package.txt
```
2. 编辑 `/data/ISO/isolinux/ks.cfg` 文件
```bash
firewall --disabled
install
cdrom
#默认的密码
rootpw --plaintext sdfsdf
auth --useshadow --passalgo=sha512
keyboard us
lang en_US
selinux --disabled
network --onboot=yes --device=eth0 --bootproto=dhcp --noipv6
skipx
logging --level=info
reboot
timezone --isUtc Asia/Shanghai
bootloader --location=mbr
zerombr
clearpart --all --initlabel
#设置boot分区500M
part /boot --fstype="ext4" --size=500
part swap --fstype="swap" --size=2048
part / --fstype="ext4" --grow --size=1
%packages --nobase
@core
%end
reboot
```
3. 编辑 `/data/ISO/isolinux/isolinux.cfg` 文件
```bash
default vesamenu.c32
#prompt 1
timeout 50                               ##等待时间
display boot.msg
menu background splash.jpg
menu title Hello Centos
menu color border 0 #ffffffff #00000000
menu color sel 7 #ffffffff #ff000000
menu color title 0 #ffffffff #00000000
menu color tabmsg 0 #ffffffff #00000000
menu color unsel 0 #ffffffff #00000000
menu color hotsel 0 #ff000000 #ffffffff
menu color hotkey 7 #ffffffff #ff000000
menu color scrollbar 0 #ffffffff #00000000
label linux
menu label ^Install PowerSoft OS
menu default
kernel vmlinuz
append ks=cdrom:/isolinux/ks.cfg initrd=initrd.img
label vesa
menu label Install system with ^basic video driver
kernel vmlinuz
append initrd=initrd.img xdriver=vesa nomodeset
label rescue
menu label ^Rescue installed system
kernel vmlinuz
append initrd=initrd.img rescue
label local
menu label Boot from ^local drive
localboot 0xffff
label memtest86
menu label ^Memory test
kernel memtest
append -
```
4. 创建软件仓库
```bash
cd /data/ISO
declare -x discinfo=$(head -1 .discinfo)
cp -r /mnt/cdrom/repodata/*.xml repodata/
createrepo -g repodata/*.xml ./
```
5. 生成新的ISO文件
```bash
mkisofs -o CentOS-6.10-KS.iso -b /data/ISO/isolinux/isolinux.bin -c /data/ISO/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T ../ISO
```
或者是下面这样制作也行
```bash
genisoimage -v -cache-inodes -joliet-long -R -J -T -V asika -o /root/centos.iso  -c  isolinux/boot.cat   -b isolinux/isolinux.bin  -no-emul-boot  -boot-load-size 4 -boot-info-table  -eltorito-alt-boot -b  images/efiboot.img  -no-emul-boot .
```

新生成的 ISO 文件存放在 /root 目录
