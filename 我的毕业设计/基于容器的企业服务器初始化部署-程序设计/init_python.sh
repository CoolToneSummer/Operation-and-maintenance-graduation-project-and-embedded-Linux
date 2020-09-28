#!/bin/bash
# create Joker
# time 4/26
#
init_python(){
    yum -y install python36 python36-devel
    # 安装 Python 库依赖
    # 配置并载入 Python3 虚拟环境
    cd /opt
    python3.6 -m venv py3  # py3 为虚拟环境名称, 可自定义
    source /opt/py3/bin/activate  # 退出虚拟环境可以使用 deactivate 命令
    pip install wheel
    pip install --upgrade pip setuptools
    # pip install -r /opt/jumpserver/requirements/requirements.txt
}