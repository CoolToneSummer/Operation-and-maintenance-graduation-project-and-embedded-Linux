#!/usr/bin/python3
# create Joker
# time 5/24
#
import re
import os
import subprocess
 
if __name__ == "__main__":
    os.system('rm -rf /tmp/xfleet')
    os.system('mkdir -p /tmp/xfleet')
    p = subprocess.Popen('docker images', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    for line in p.stdout.readlines():
 
        # 此处的正则表达式是为了匹配镜像名以redis为开头的镜像
        # 实际使用中根据需要自行调整
        m = re.match(r'(^redis[^\s]*\s*)\s([^\s]*\s)', line.decode("utf-8"))
        if not m:
            continue
 
        # 镜像名
        iname = m.group(1).strip(' ')
        # tag
        itag = m.group(2)
 
        # tar包的名字
        tarname = iname.split('/')[-1]
        print(tarname)
        tarball = tarname + '.tar'
        ifull = iname + ':' + itag
        #save
        cmd = 'docker save -o ' + tarball + ' ' + ifull
        os.system(cmd)
 
        # 将tar包放在临时目录
        os.system('mv %s /tmp/xfleet/'%tarball)
 
 
    retval = p.wait()