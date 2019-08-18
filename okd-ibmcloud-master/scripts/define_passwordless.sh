#!/bin/bash
#This script defines the passwordless connection to all nodes

#LOGFILE=/tmp/addosuser.log
#exec > $LOGFILE 2>&1

echo "=================================================="
echo "= Start of define_passwordless.sh"
echo "= Parameter 1 (master ips)    : $1"
echo "= Parameter 2 (compute ips)   : $2"
echo "=================================================="

all_hosts=$1' '$2

for i in ${all_hosts[@]}; do
    echo "= Defining passwordless for IP: "${i}
    ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa root@${i}
    echo "= Defining known_hosts using ssh-keyscan"
    ssh-keyscan ${i} >> /root/.ssh/known_hosts
done

for i in ${all_hosts[@]}; do
    echo "= Attempting to access IP: "${i}
    ssh root@${i} "hostname;exit"
done

echo "=================================================="
echo "= End of define_passwordless.sh"
echo "=================================================="

exit 0