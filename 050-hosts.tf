#--------------------------------------------------------------------------------------------------------
#---- Modify the /etc/hosts file on each system that has been created
#--------------------------------------------------------------------------------------------------------
resource "null_resource" "hosts_file" {
  depends_on = ["ibm_compute_vm_instance.master", "ibm_compute_vm_instance.compute", "null_resource.passwordless"]

  # on each host edit the /etc/host file an add new entires
  count = "${local.cluster_size}"

  # using the local.all_ips access each server and modify the host /etc/hosts file
  connection {
    host                = "${element(local.all_ips, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${tls_private_key.ssh.private_key_pem}"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/hosts_file.sh"
    destination = "/tmp/hosts_file.sh"
  }

#   "/tmp/hosts_file.sh ${var.host_base} ${var.host_tail} ${local.all_master_public} ${local.all_compute_public}"    

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/hosts_file.sh",
      "/tmp/hosts_file.sh ${var.host_base} ${var.host_tail} ${join(",", ibm_compute_vm_instance.master.*.ipv4_address)}  ${join(",", ibm_compute_vm_instance.compute.*.ipv4_address)}"    
      ]
  }
}


