#--------------------------------------------------------------------------------------------------------
#
# IBM Cloud Provider for Terraform
# https://ibm-cloud.github.io/tf-ibm-docs/ 
#
#--------------------------------------------------------------------------------------------------------
provider "ibm" {
  softlayer_username  = "${var.ibm_api_username}"
  softlayer_api_key   = "${var.ibm_api_key}"
}
