#!/bin/bash
#Change host name

echo "=================================================="
echo "= Start of namehost.sh"
echo "= Parameter 1 (host_base)    : $1"
echo "= Parameter 2 (VM ip)        : $2"
echo "= Parameter 3 (host_io)      : $3"
echo "=================================================="
echo " "

newname=$1.$2.$3
# issue command to update host name
sudo hostnamectl set-hostname $newname

echo "= Set hostname to: $newname"

echo " "
echo "=================================================="
echo "= End of namehost.sh"
echo "=================================================="
