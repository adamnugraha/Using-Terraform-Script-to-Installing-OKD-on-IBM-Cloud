#--------------------------------------------------------------------------------------------------------
#---- Prep the newly created VMs with the needed software to install Openshift OKD
#--------------------------------------------------------------------------------------------------------
resource "null_resource" "okd_prep" {
  depends_on = ["null_resource.hosts_file"]

  # on each node in the environment copy and run the prep script
  count = "${local.cluster_size}"

  connection {
    host                = "${element(local.all_ips, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${tls_private_key.ssh.private_key_pem}"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/okd_prep.sh"
    destination = "/tmp/okd_prep.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/nfs_storage.sh"
    destination = "/tmp/nfs_storage.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/okd_prep.sh","/tmp/okd_prep.sh ${var.okd_version} ${var.okd_user}"    
      ]
  }
}