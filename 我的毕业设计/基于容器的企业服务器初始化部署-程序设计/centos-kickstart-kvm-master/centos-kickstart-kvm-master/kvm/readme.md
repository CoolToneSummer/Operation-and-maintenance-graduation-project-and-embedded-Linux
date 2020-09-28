# KVM 安装


1. 安装主要软件包: 

```
libvirt
virt-install  
qemu (或者 qemu-kvm)
bridge-utils (桥接网络使用)
```

2. 加载Linux内核模块
```bash
modprobe kvm
modprobe kvm_intel
```
3. 启动 `libvirtd.service`
```bash
systemctl start libvirtd.service
```