#--------------------------------------------------------------------------------------------------------
#---- New local variables with information from defined VMs
#--------------------------------------------------------------------------------------------------------

locals {
  depends_on = ["ibm_compute_vm_instance.master", "ibm_compute_vm_instance.compute"]
  
  
  master_ip      = "${ibm_compute_vm_instance.master.0.ipv4_address}"
  compute1_ip    = "${ibm_compute_vm_instance.compute.0.ipv4_address}"
  compute2_ip    = "${ibm_compute_vm_instance.compute.0.ipv4_address}"

  master_name   = "${var.host_base}.${ibm_compute_vm_instance.master.0.ipv4_address}.${var.host_io}"
  compute1_name = "${var.host_base}.${ibm_compute_vm_instance.compute.0.ipv4_address}.${var.host_io}"
  compute2_name = "${var.host_base}.${ibm_compute_vm_instance.compute.0.ipv4_address}.${var.host_io}"

  all_master_public   = "${join(" ", ibm_compute_vm_instance.master.*.ipv4_address)}"
  all_master_private  = "${join(" ", ibm_compute_vm_instance.master.*.ipv4_address_private)}"
  all_master_names    = "${join(" ", ibm_compute_vm_instance.master.*.hostname)}"

  all_compute_public   = "${join(" ", ibm_compute_vm_instance.compute.*.ipv4_address)}"
  
  all_compute_private  = "${join(" ", ibm_compute_vm_instance.compute.*.ipv4_address_private)}"
  
  all_compute_names    = "${join(" ", ibm_compute_vm_instance.compute.*.hostname)}"

  cluster_size = "${var.master["nodes"] + var.compute["nodes"]}"
  all_ips      = "${concat(ibm_compute_vm_instance.master.*.ipv4_address, ibm_compute_vm_instance.compute.*.ipv4_address)}"

  all_ips_pp   = "${concat(ibm_compute_vm_instance.master.*.ipv4_address, ibm_compute_vm_instance.master.*.ipv4_address_private, ibm_compute_vm_instance.compute.*.ipv4_address, ibm_compute_vm_instance.compute.*.ipv4_address_private)}"

}

output "all_network_ips" {
  value = ["${local.all_ips}"]
}