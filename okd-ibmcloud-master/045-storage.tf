#--------------------------------------------------------------------------------------------------------
#---- Define NFS storage for use in the OKD cluster 
#---- allowed_ip_addresses will be the public and private ip addresses for the defined cluster
#--------------------------------------------------------------------------------------------------------

resource "ibm_storage_file" "nfs" {
    depends_on = ["ibm_compute_vm_instance.master", "ibm_compute_vm_instance.compute"]

    type = "Performance"
    datacenter = "${var.datacenter}"
    capacity = "${var.storage_space}"
    iops = 100
    allowed_ip_addresses = [ "${local.all_ips_pp}" ]
    hourly_billing = true
}