#!/bin/bash
#This script is used to obtain and prep okd install files

#LOGFILE=/tmp/okd_build.log
#exec > $LOGFILE 2>&1

echo "=================================================="
echo "= Start of okd_build.sh"
echo "= Parameter 1 (okd_user)     : $1"
echo "= Parameter 2 (okd_password) : $2"
echo "=================================================="

echo " "
echo "= 0. Change to /tmp directory"
echo " "
cd /tmp

echo " "
echo "= 1. Add the openshift-ansible package to the master node"
echo " "
sudo yum -y install openshift-ansible > /tmp/ansible_install.log

echo " "
echo "= 2. Downgrade the version of ansible to 2.6.0"
echo " "
sudo pip install ansible==2.6.0 > /tmp/downgrade-ansible.log

echo " "
echo "= 3. Ansible prerequisites install "
echo " "
#sudo ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml -i /tmp/inventory.cfg | tee okd-prereg.log
sudo ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook /tmp/openshift-ansible/playbooks/prerequisites.yml -i /tmp/inventory.cfg | tee okd-prereg.log

echo " "
echo "= 4. Ansible deploy cluster"
echo " "
#sudo ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml -i /tmp/inventory.cfg | tee okd-deploy.log
sudo ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook /tmp/openshift-ansible/playbooks/deploy_cluster.yml -i /tmp/inventory.cfg | tee okd-deploy.log

echo " "
echo "= 5. Adding user to local file"
echo " "
htpasswd -b -c /etc/origin/master/htpasswd $1 $2

echo " "
echo "= 6. Login with oc -u system:admin"
echo " "
cd /root
oc login -u system:admin

echo " "
echo "= 7. Adding user to local file"
echo " "
htpasswd -b -c /etc/origin/master/htpasswd $1 $2

echo " "
echo "= 8. Granting administration rights to user"
echo " "
oc adm policy add-cluster-role-to-user cluster-admin $1

echo " "
echo "=================================================="
echo "= End of okd_build.sh"
echo "=================================================="


 