#!/bin/bash
#This script will echo instructions to the installer after all steps are completed

##########
# Colors #
##########
Banner='\033[30;47m'
Red='\x1B[0;31m'
Cyan='\x1B[0;36m'
FillGreen='\033[30;42m'
Fill='\x1b[103m'
no_color='\x1B[0m' # No Color
eyes='\xF0\x9F\x91\x80'
REDFILL='\x1b[41m'
##########
echo " "
echo "=================================================="
echo "= Start of completed.sh"
echo "= Parameter 1 (master ip)    : $1"
echo "= Parameter 2 (okd_user)     : $2"
echo "= Parameter 3 (okd_password) : $3"
echo "=================================================="


echo -e "${no_color}"
echo -e "${Fill}                ${eyes} Installation finished ${eyes}                         ${no_color}"

echo " "
echo -e "${Fill} Optional Task - login to OKD instance from local machine           ${no_color}"
echo " "
echo "Using the oc CLI (assumes you have already installed the oc CLI on this computer) login to the cluster using the following:"
echo " "
echo -e "      ${Red}oc login https://$1:8443 -u $2 -p $3 --insecure-skip-tls-verify=false${no_color}"
echo " "
echo "  Reply yes to the following prompt"
echo " "
echo "  The server uses a certificate signed by an unknown authority."
echo "  You can bypass the certificate check, but any data you send to the server could be intercepted by others."
echo "  Use insecure connections? (y/n):"
echo " "
echo "Execute the following command:"
echo " "
echo -e "      ${Red}oc get pods${no_color}"
echo " "
echo "Execute the following command:"
echo " "
echo -e "      ${Red}oc logout${no_color}"
echo " "

echo " "
echo -e "${Fill} Optional Task - Access the OKD master VM                           ${no_color}"
echo " "
echo "Execute the following command to access the newly created master VM:"
echo " "
echo -e "      ${Red}ssh -i sshkey root@$1${no_color}    (command example is using the default ssh key)${no_color}"
echo " "

echo " "
echo -e "${Fill} Optional Task - Access the OKD browser interface                   ${no_color}"
echo " "
echo "Execute the following command to open the OKD browser interface:"
echo " "
echo -e "      ${Red}open https://$1:8443${no_color}    (User: $2 Password: $3)"
echo " "
echo " "
echo "Or manually open a browser and navigate to this url:"
echo " "
echo -e "      ${Red}https://$1:8443${no_color}    (User: $2 Password: $3)"
echo " "
echo " "
echo -e "${Fill} Optional Task - Was dynamic storage defined?                       ${no_color}"
echo " "
echo "If cluster dynamic storage was defined view the storage."
echo " "
echo -e "      ${Red}oc get storageclass${no_color}"
echo " "
echo -e "      ${Red}oc describe storageclass managed-nfs-storage${no_color}"
echo " "
echo -e "Note the storage is ${Red}NOT${no_color} set as default class. To set as default perform the following:"
echo " "
echo -e "      ${Red}oc patch storageclass managed-nfs-storage -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"true\"}}}'${no_color}"
echo " "
echo "  Example output if storage default is patched:"
echo " "
echo "  storageclass.storage.k8s.io/managed-nfs-storage patched"
echo " "
echo " "
echo -e "${Fill}Select and run the above optional tasks to validate the install.    ${no_color}"
echo " "
echo " "
# get the 
cf=$(ssh -q -i sshkey root@$1 -o StrictHostKeyChecking=no  -o UserKnownHostsFile=/dev/null  [[ -f /tmp/bound_pass.txt ]] && echo "PASS" || echo "FAIL";)

    if [[ "$cf" == "FAIL" ]]; then
        echo -e "${REDFILL} Possible failed installation. Issues occurred deploying pods.      ${no_color}"
    elif [[ "$cf" == "PASS" ]]; then
        echo -e "${FillGreen} Installation was able to successfully deploy pod for storage       ${no_color}"
    fi

echo "=================================================="
echo "= End of completed.sh"
echo "=================================================="

exit 0
