
#$SERVERIP=`ip addr | grep 'state UP' -A2 | grep inet | egrep -v '(127.0.0.1|inet6|docker)' | awk '{print $2}' | tr -d "addr:" | head -n 1 | cut -d / -f1`
redis-server  /config/nodes-${PORT}.conf

if [[ ${PORT} -eq 6391 ]];then
redis-cli --cluster create 192.168.237.148:6391 \
                           192.168.237.148:6392 \
                           192.168.237.148:6393 \
                           192.168.237.148:6394 \
                           192.168.237.148:6395 \
                           192.168.237.148:6396 \
                           --cluster-replicas 1
fi

# 验证测试集群
# redis-cli -h 192.168.237.148 -p 6391
# set test 1
# redis-cli -c -h 192.168.237.133 -p 6391 set test 1
# redis-cli -c -h 192.168.237.133 -p 6391 get test