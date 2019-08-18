#!/bin/bash
#This script defines the passwordless connection to all nodes

#LOGFILE=/tmp/self_certs.log
#exec > $LOGFILE 2>&1

echo "=================================================="
echo "= Start of self_certs.sh"
echo "=================================================="

sudo mkdir -p /root/.ssh
echo "= Created directory .ssh"

cp /tmp/id_rsa /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
echo "= Copied id_rsa"

cp /tmp/id_rsa /root/.ssh/id_rsa.pub
chmod 644 /root/.ssh/id_rsa.pub
echo "= Copied id_rsa.pub"

echo "=================================================="
echo "= End of self_certs.sh"
echo "=================================================="

exit 0