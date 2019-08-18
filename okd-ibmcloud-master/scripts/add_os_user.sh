#!/bin/bash
#This script adds user to OS and su privledges

#LOGFILE=/tmp/addosuser.log
#exec > $LOGFILE 2>&1

echo "=================================================="
echo "= Start of add_os_user.sh"
echo "= Parameter 1 (os_user)     : $1"
echo "= Parameter 2 (os_password) : $2"
echo "=================================================="

#Check if user is to be defined
if [ -z "$1" ] 
  then
    echo "= NO user will be created, no information provided"
  else
    echo "= Creating new user"
    useradd -m $1 -p $2
    echo $2 | passwd --stdin $1
    echo "= Add user to su group"
    usermod -aG wheel $1
fi

echo "=================================================="
echo "= End of add_os_user.sh"
echo "=================================================="

exit 0