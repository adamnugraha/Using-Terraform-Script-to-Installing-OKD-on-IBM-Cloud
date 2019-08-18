#!/bin/bash
#This script will install the NFS dynamic provisioner on the master

echo "=================================================="
echo "= Start of nfs_storage.sh"
echo "= Parameter 1 (nfs_hostname)    : $1"
echo "= Parameter 2 (nfs_mountpoint)  : $2"
echo "=================================================="
#---

echo "Create NFS storage provisioner"
oc new-project nfsprov
oc project nfsprov

echo "= Get storage zip"
curl -L -o kubernetes-incubator.zip https://github.com/kubernetes-incubator/external-storage/archive/master.zip

echo "= Unzip storage zip"
unzip kubernetes-incubator.zip > /tmp/nfsunzip.log

echo "= Unzip completed"
echo "= Change to directory for newly extracted content"
cd external-storage-master/nfs-client/

echo "= Create OKD storage provisioner project: nfsprov"
oc new-project nfsprov
oc project nfsprov

echo "= Edit file: rbac.yaml"
NAMESPACE="nfsprov"
sudo sed -i -e 's@namespace:.*@namespace: '"$NAMESPACE"'@g' ./deploy/rbac.yaml

echo "= Create the service account and role bindings"
oc create -f deploy/rbac.yaml
oc adm policy add-scc-to-user hostmount-anyuid system:serviceaccount:$NAMESPACE:nfs-client-provisioner

# set the NFS server value
SERV=$1

# set the NFS path value
DIRP="$(cut -d':' -f2 <<<"$2")"

echo "= Edit file: deploy/deployment.yaml"
sudo sed -i -e 's@fuseim.pri/ifs@myokd/nfs@g' ./deploy/deployment.yaml
sudo sed -i -e 's@10.10.10.60@'"$SERV"'@g' ./deploy/deployment.yaml
sudo sed -i -e 's@/ifs/kubernetes@'"$DIRP"'@g' ./deploy/deployment.yaml

echo "= Edit file: deploy/class.yaml"
sudo sed -i -e 's@fuseim.pri/ifs@myokd/nfs@g' ./deploy/class.yaml

echo "= Create OKD resources"
oc create -f ./deploy/class.yaml
oc create -f ./deploy/deployment.yaml

#echo "= Get pods"
#oc get pods

echo "= Creating test PVC"
oc create -f ./deploy/test-claim.yaml

echo "= Checking status of test PVC"
pvcindex=1
pvcretries=20
pvcstay="T"
while [ "$pvcstay" = "T" ] ; do
    # get the status of the PVC
    line=$(oc get pvc test-claim --no-headers)

    # parse for Bound in second value of status line
    pvcStatus=$(echo ${line} | awk '{print $2}')

    # check result
    if [[ "$pvcStatus" == "Pending" ]]; then
        echo "= Waiting for PVC to bind storage, completed $pvcindex of $pvcretries wait cycles."
    elif [[ "$pvcStatus" == "Bound" ]]; then
        echo "= Storage PVC is successfully Bound"
        echo "= Defined storage-class: managed-nfs-storage"
        touch /tmp/bound_pass.txt
        break
    fi

    # Did not find Bound as status, wait 5 seconds and retry
    sleep 6
    pvcindex=$(( pvcindex + 1 ))
    if [[ $pvcindex -eq $pvcretries ]]; then
        echo "= WARNING: Does not appear the storage is properly installed and configured"
        touch /tmp/bound_fail.txt
    	break
    fi
done

echo "=================================================="
echo "= End of nfs_storage.sh"
echo "=================================================="