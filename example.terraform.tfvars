#--------------------------------------------------------------------------------------------------------
#
# This file provides user defined values as needed to install OKD in the IBM Cloud using Terraform.
# Provide user values to override the default values as defined in the 000-variables.tf file.  
# 
# The user provided values will override what is defined in the 00-variables.tf file.
#
# REQUIRED PARAMETERS:
#   ibm_api_username
#   ibm_api_key
#   datacenter
#--------------------------------------------------------------------------------------------------------
# IBMCloud / Softlayer related credentals and datacenter parameters 
#
# - API user name and API key.  Obtained from the IBM Cloud browser based user interface.
ibm_api_username = "IBM6761618"
ibm_api_key = "9e1fef9f7c497307faffd907f761173735cb96dc287a02041418fc91449b69b9"
#
# - Datacenter code for the location of where the VM(s) will be deployed.
# - Refer to this link for information regarding all valid datacenter codes:
# - https://cloud.ibm.com/gen1/infrastructure/provision/vs
datacenter = "dal13"

