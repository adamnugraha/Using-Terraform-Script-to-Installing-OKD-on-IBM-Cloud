#!/bin/bash

echo "=================================================="
echo "= Start of initial_prep.sh"
echo "=================================================="

LOGFILE=/tmp/initial.log
exec > $LOGFILE 2>&1

linux_install(){

  echo "=================================================="
  echo "= Prepare step 1"
  echo "=================================================="
  sudo yum -y check-update

  echo "=================================================="
  echo "= Prepare step 2"
  echo "=================================================="
  sudo yum update -y

  echo "=================================================="
  echo "= Prepare step 3"
  echo "=================================================="
  
  sudo yum install -y python socat nano nfs-utils ntp ntpdate glusterfs-client lvm2 rsync device-mapper-persistent-data \
  wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct \
  jq nfs-utils lvm2 python-setuptools policycoreutils-python unzip sshpass java-1.8.0-openjdk-headless python-passlib
  
  echo "=================================================="
  echo "= Prepare step 4"
  echo "=================================================="
  sudo yum update -y

  echo "=================================================="
  echo "= Prepare step 5"
  echo "=================================================="
  # might need to change if centos version 8 is used
  sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  
  echo "=================================================="
  echo "= NTP setup"
  echo "=================================================="
  sudo systemctl enable ntpd
  sudo systemctl start ntpd

}

linux_install

echo "=================================================="
echo "= End of initial_prep.sh"
echo "=================================================="

exit 0
