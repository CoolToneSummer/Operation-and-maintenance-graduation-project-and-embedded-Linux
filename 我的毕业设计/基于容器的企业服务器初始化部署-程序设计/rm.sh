#!/bin/bash
# create Joker
# time 5/12
# 

# linux系统的rm命令太危险，一不小心就会删除掉系统文件。
# 写一个shell脚本来替换系统的rm命令，要求当删除一个文件或者目录时，都要做一个备份，然后再删除。
# 逻辑
# 不知道哪个分区有剩余空间，在删除之前先计算要删除的文件或者目录大小，然后对比系统的磁盘空间，
# 如果够则按照上面的规则创建隐藏目录，并备份，如果没有足够空间，要提醒用户没有足够的空间备份并提示是否放弃备份，
# 如果用户输入yes，则直接删除文件或者目录，如果输入no，则提示未删除，然后退出脚本

fileName=$1
now=`date +%Y%m%d%H%M`
f_size=`du -sk $1 |awk '{print $1}'`
disk_size=`LANG=en; df -k |grep -vi filesystem |awk '{print $4}' |sort -n |tail -n1`
big_filesystem=`LANG=en; df -k |grep -vi filesystem |sort -n -k4 |tail -n1 |awk '{print $NF}'`
 
if [ $f_size -lt $disk_size ]
then
   read -p "Are you sure delete the file or directory: $1 ? yes|no: " input
   if [ $input == "yes" ] || [ $input == "y" ]
   then
      mkdir -p $big_filesystem/.$now && rsync -aR $1 $big_filesystem/.$now/ && /bin/rm -rf $1
   elif [ $input == "no" ] || [ $input == "n" ]
   then
      exit 0
   else
      echo "Only input 'yes' or 'no'."
   fi
else
   echo "The disk size is not enough to backup the file: $1."
   read -p "Do you want to delete "$1"? yes|no: " input
   if [ $input == "yes" ] || [ $input == "y" ]
   then
       echo "It will delete "$1" after 5 seconds whitout backup."
       for i in `seq 1 5`; do echo -ne "."; sleep 1; done
     echo
       /bin/rm -rf $1
   elif [ $input == "no" ] || [ $input == "n" ]
   then
       echo "It will not delete $1."
       exit 0
   else
       echo "Only input 'yes' or 'no'."
   fi
fi