#!/bin/bash
#This script defines the passwordless connection to all nodes

#LOGFILE=/tmp/hostname.log
#exec > $LOGFILE 2>&1

echo "=================================================="
echo "= Start of hosts_file.sh"
echo "= Parameter 1 (host_base)       : $1"
echo "= Parameter 2 (host_tail)       : $2"
echo "= Parameter 3 (master ips)      : $3"
echo "= Parameter 4 (compute ips)     : $4"
echo "=================================================="
#---
# this script builds another script build_host.sh that contains the required
# sed commands to modify the /etc/hosts file
#---

#--- start creating the new shell file
cmd00="#!/bin/bash"
echo $cmd01 > /tmp/build_host.sh
echo "echo ==================================================" >> /tmp/build_host.sh
echo "echo = Modifiy /etc/hosts" >> /tmp/build_host.sh

#--- edit the manage_etc_host setting to be False
cmd01="sudo sed -i -e 's/manage_etc_hosts: True/manage_etc_hosts: False/g' /etc/cloud/cloud.cfg"
echo $cmd01 >> /tmp/build_host.sh

#--- comment out the ipV6 entries in the /etc/hosts file
cmd02="sudo sed -i -e 's/::/#::/g' /etc/hosts"
echo $cmd02 >> /tmp/build_host.sh

# comment out the entries for 127.0.0 in the /etc/hosts file
cmd03="sudo sed -i -e 's/127.0.0/#127.0.0/g' /etc/hosts"
echo $cmd03 >> /tmp/build_host.sh

# parts of sed command used to build each entry for adding each host to the /etc/hosts file
fp="sudo sed -i -e '"
mp="$"a"\\"
lp="\\' /etc/hosts"

#--- MASTER node(s)
# example command that will the built to add new line to the /etc/hosts file
#    sudo sed -i -e '$a\10.10.10.10 bob\' /etc/hosts

if [[ $3 = *,* ]]; then
    echo "= More than one master node defined"
    j=$3
    masters=${j//,/ }
else
    echo "= Single master node defined"
    masters=$3
fi

cnt=1

for i in ${masters[@]}; do
    echo "= Building /etc/hosts file entry for master IP: "${i}

    ent=${i}" master"$cnt"."$1.$2"  master"$cnt
    cnt=$((cnt+1))
    echo $fp$mp$ent$lp >> /tmp/build_host.sh
    echo $ent
done

#--- COMPUTE node(s)
# example command that will the built to add new line to the /etc/hosts file
#    sudo sed -i -e '$a\10.10.10.10 bob\' /etc/hosts


if [[ $4 = *,* ]]; then
    echo "= More than one compute node defined"
    k=$4
    compute=${k//,/ }
else
    echo "= Single compute node defined"
    compute=$4
fi

cnt=1
for i in ${compute[@]}; do
    echo "= Building /etc/hosts file entry for compute IP: "${i}
    ent=${i}" compute"$cnt"."$1.$2"  compute"$cnt
    cnt=$((cnt+1))
    echo $fp$mp$ent$lp >> /tmp/build_host.sh
    echo $ent
done

#--- end of shell, exit with 0
echo "echo ==== End of modifiy" >> /tmp/build_hosts.sh
echo "exit 0" >> /tmp/build_host.sh

#--- Enable the newly created shell file to be executed
sudo chmod +x /tmp/build_host.sh

#--- Execute the newly created shell file
sh /tmp/build_host.sh

echo "=================================================="
echo "= End of hosts_file.sh"
echo "=================================================="

exit 0
