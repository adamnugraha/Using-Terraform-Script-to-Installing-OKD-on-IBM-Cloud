
#--------------------------------------------------------------------------------------------------------
#---- Define ssh and passwordless connection to all VMs 
#---- Example command: sshpass -p <password>  ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub okdadmin@<node ip>
#--------------------------------------------------------------------------------------------------------


resource "null_resource" "passwordless" {
  depends_on = ["ibm_compute_vm_instance.master", "ibm_compute_vm_instance.compute"]

  connection {
    host                = "${local.master_ip}"
    user                = "${var.ssh_user}"
    private_key         = "${tls_private_key.ssh.private_key_pem}"
  }
  
  provisioner "file" {
    source      = "${path.module}/scripts/define_passwordless.sh"
    destination = "/tmp/define_passwordless.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/define_passwordless.sh",
      "/tmp/define_passwordless.sh ${local.all_master_public} ${local.all_compute_public}"
    ]
  }
}

