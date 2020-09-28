# 全自动安装ISO制作


操作与centos6 基本相同

注意事项: 

1. `isolinux.cfg` 文件直接拷贝ISO内的即可,需要修改两处, 指定ks文件
```bash
label linux
  menu label ^Install CentOS 7
  kernel vmlinuz
  append ks=cdrom:/isolinux/ks.cfg  initrd=initrd.img

label check
  menu label Test this ^media & install CentOS 7
  menu default
  kernel vmlinuz
  append ks=cdrom:/isolinux/ks.cfg  initrd=initrd.img

```


## ks.cfg文件

与centos6没有区别,主要是保证通用性

```bash
firewall --disabled
install
cdrom
text
rootpw --plaintext sdfsdf
auth --useshadow --passalgo=sha512
keyboard us
lang en_US
selinux --disabled
network --onboot=yes --device=eth0 --bootproto=dhcp --noipv6
skipx
logging --level=info
timezone --isUtc Asia/Shanghai
bootloader --location=mbr
zerombr
clearpart --all --initlabel
part /boot --fstype="ext4" --size=500
part swap --fstype="swap" --size=2048
part / --fstype="ext4" --grow --size=1
%packages --nobase
@core
%end
%post
sed  -i "s/timeout=5/timeout=0/g"  /boot/grub2/grub.cfg
yum install   bash-completion  vim java-1.8.0-openjdk  net-tools -y
%end
reboot

```

# 说明

1. `%package` 与 `%end` 配对使用: 用于安装包组
2. `%pre` 与 `%end` 配对使用: 安装系统之前执行的脚本
3. `%post` 与 `%end` 配对使用: 安装系统之后执行的脚本 