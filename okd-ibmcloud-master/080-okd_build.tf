#--------------------------------------------------------------------------------------------------------
#---- Modify the /etc/hosts file on each system that has been created
#--------------------------------------------------------------------------------------------------------
resource "null_resource" "okd_build" {
  depends_on = ["null_resource.okd_prep"]

  connection {
    host                = "${ibm_compute_vm_instance.master.0.ipv4_address}"
    user                = "${var.ssh_user}"
    private_key         = "${tls_private_key.ssh.private_key_pem}"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/okd_build.sh"
    destination = "/tmp/okd_build.sh"
  }

  # create the inventory.cfg file on the remote host
  provisioner "file" {
    content     = "${data.template_file.inventory.rendered}"
    destination = "/tmp/inventory.cfg"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/okd_build.sh","/tmp/okd_build.sh  ${var.okd_user} ${var.okd_password}",
        "chmod +x /tmp/nfs_storage.sh","/tmp/nfs_storage.sh  ${ibm_storage_file.nfs.hostname} ${ibm_storage_file.nfs.mountpoint}"
      ]
  }
}
