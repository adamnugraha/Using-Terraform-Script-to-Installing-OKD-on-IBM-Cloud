#--------------------------------------------------------------------------------------------------------
#---- Output information 
#--------------------------------------------------------------------------------------------------------

output "cloud_domain" {
  value = ["${var.cloud_domain}"]
}
output "all_ips" {
  value = ["${ibm_compute_vm_instance.master.*.ipv4_address}", 
           "${ibm_compute_vm_instance.master.*.ipv4_address_private}",
           "${ibm_compute_vm_instance.compute.*.ipv4_address}",
           "${ibm_compute_vm_instance.compute.*.ipv4_address_private}"
           ]
}
output "all_compute_names" {
  value = ["${ibm_compute_vm_instance.compute.*.hostname}"]
}
output "all_master_names" {
  value = ["${ibm_compute_vm_instance.master.*.hostname}"]
}
output "compute_private_ip" {
  value = ["${ibm_compute_vm_instance.compute.*.ipv4_address_private}"]
}
output "compute_public_ip" {
  value = ["${ibm_compute_vm_instance.compute.*.ipv4_address}"]
}
output "master_public_ip" {
  value = ["${ibm_compute_vm_instance.master.*.ipv4_address}"]
}
output "master_private_ip" {
  value = ["${ibm_compute_vm_instance.master.*.ipv4_address_private}"]
}
output "nfs_hostname" {
  value = ["${ibm_storage_file.nfs.hostname}"]
}
output "nfs_mountpoint" {
  value = ["${ibm_storage_file.nfs.mountpoint}"]
}
output "nfs_volumename" {
  value = ["${ibm_storage_file.nfs.volumename}"]
}


#--------------------------------------------------------------------------------------------------------
#---- Execute local script with installation information 
#--------------------------------------------------------------------------------------------------------
resource "null_resource" "end" {
  depends_on = ["null_resource.okd_build"]
  provisioner "local-exec" {
    command = "./scripts/completed.sh ${ibm_compute_vm_instance.master.0.ipv4_address} ${var.okd_user} ${var.okd_password}"
  }
}