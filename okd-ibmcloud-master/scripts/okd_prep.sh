#!/bin/bash
#This script is used to prep the nodes for install

#LOGFILE=/tmp/okd_prep.log
#exec > $LOGFILE 2>&1

echo "=================================================="
echo "= Start of okd_prep.sh"
echo "= Parameter 1 (okd_version)    : $1"
echo "= Parameter 2 (okd_user)       : $2"
echo "=================================================="

echo " "
echo "= 1. Change to /tmp directory"
echo " "
cd /tmp

echo " "
echo "= 2. Enable the EPEL repository"
echo " "
sudo yum -y install epel-release > /tmp/epel_01.log

# will need to be updated when centos 8 is used
# some of the following is based on these instructions:  https://docs.okd.io/3.11/install/host_preparation.html

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm > /tmp/epel_02.log

sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

sudo yum -y --enablerepo=epel install ansible pyOpenSSL > /tmp/epel_03.log

echo " "
echo "= 3. Install docker, git, and pyOpenSSL"
echo " "
sudo yum -y install docker git > /tmp/docker_install.log

echo " "
echo "= 4. Install pip via curl"
echo " "
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" > pip_download.log
python get-pip.py

echo " "
echo "= 5. Check pip verison"
echo " "
pip -V

echo " "
echo "= 6. Get the the OKD packages"
echo " "
git clone https://github.com/openshift/openshift-ansible > /tmp/git_clone.log

echo " "
echo "= 7. Change to openshift-ansible directory"
echo " "
cd openshift-ansible

echo " "
echo "= 8. GIT checkout the OKD release-3.11 version"
echo " "
git checkout release-3.11 > /tmp/git_checkout.log

echo " "
echo "= 9. Enable, start and display info for docker"
echo " "
sudo systemctl enable docker
sudo systemctl start docker
sudo docker info

echo " "
echo "= 10. Enable and start NetworkManager"
echo " "
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager


echo " "
echo "= 11. Edit ifcfg-ethX files"
echo " "
sudo sed -i -e 's/NM_CONTROLLED=no/NM_CONTROLLED=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0
sudo sed -i -e 's/NM_CONTROLLED=no/NM_CONTROLLED=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth1

echo " "
echo "= 12. Add docker group and add users to group"
echo " "
sudo groupadd docker
sudo usermod -aG docker $USER
sudo usermod -aG docker $2

sudo getent group | grep docker

echo " "
echo "= End of okd_prep.sh"
echo "=================================================="

exit 0
