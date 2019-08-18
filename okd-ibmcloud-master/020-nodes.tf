#--------------------------------------------------------------------------------------------------------
#---- Master node(s)
#--------------------------------------------------------------------------------------------------------

resource "ibm_compute_vm_instance" "master" {
  lifecycle {
    ignore_changes     = ["private_vlan_id"]
  }
  cores                = "${var.master["cpu_cores"]}"
  count                = "${var.master["nodes"]}"
  datacenter           = "${var.datacenter}"
  disks                = ["${var.master["disk_size"]}"]
  domain               = "${var.cloud_domain}"  
  hostname             = "${format("%s-%s-%01d", lower(var.host_base), lower(var.master["name"]),count.index + 1 )}"
  hourly_billing       = "${var.master["hourly_billing"]}"
  local_disk           = "${var.master["local_disk"]}"
  memory               = "${var.master["memory"]}"
  network_speed        = "${var.master["network_speed"]}"
  os_reference_code    = "${var.os_reference}"
  private_network_only = "${var.master["private_network_only"]}"
  ssh_key_ids          = ["${ibm_compute_ssh_key.ibm_public_key.id}"]
  tags                 = ["${var.master_tag}"]

  connection {
    user               = "${var.ssh_user}"
    private_key        = "${tls_private_key.ssh.private_key_pem}"
    host               = "${self.ipv4_address}"
  }
  # copy local files to newly created VM
  provisioner "file" {
    source             = "${path.cwd}/${var.ssh_key_name}${local.priv}"
    destination        = "/tmp/id_rsa"
  }
  provisioner "file" {
    source             = "${path.cwd}/${var.ssh_key_name}${local.pub}"
    destination        = "/tmp/id_rsa.pub"
  }
  provisioner "file" {
    source             = "${path.module}/scripts/self_certs.sh"
    destination        = "/tmp/self_certs.sh"
  }
  provisioner "file" {
    source             = "${path.module}/scripts/add_os_user.sh"
    destination        = "/tmp/add_os_user.sh"
  }
  provisioner "file" {
    source             = "${path.module}/scripts/namehost.sh"
    destination        = "/tmp/namehost.sh"
  }
  provisioner "file" {
    source             = "${path.module}/scripts/initial_prep.sh"
    destination        = "/tmp/initial_prep.sh"
  }  


  provisioner "remote-exec" {
    inline             = [
      "chmod +x /tmp/namehost.sh; sudo /tmp/namehost.sh ${var.host_base} ${self.ipv4_address} ${var.host_io}",
      "chmod +x /tmp/initial_prep.sh; sudo /tmp/initial_prep.sh",
      "chmod +x /tmp/add_os_user.sh; sudo /tmp/add_os_user.sh ${var.os_user} ${var.os_password}",
      "chmod +x /tmp/self_certs.sh; sudo /tmp/self_certs.sh"
    ]
  }
}


#--------------------------------------------------------------------------------------------------------
#---- Computer node(s)
#--------------------------------------------------------------------------------------------------------

resource "ibm_compute_vm_instance" "compute" {
  lifecycle {
    ignore_changes     = ["private_vlan_id"]
  }

  cores                = "${var.compute["cpu_cores"]}"
  count                = "${var.compute["nodes"]}"
  datacenter           = "${var.datacenter}"
  disks                = ["${var.compute["disk_size"]}"]
  domain               = "${var.cloud_domain}"
  hostname             = "${format("%s-%s-%01d", lower(var.host_base), lower(var.compute["name"]),count.index + 1 )}"
  hourly_billing       = "${var.compute["hourly_billing"]}"
  local_disk           = "${var.compute["local_disk"]}"
  memory               = "${var.compute["memory"]}"
  network_speed        = "${var.compute["network_speed"]}"
  os_reference_code    = "${var.os_reference}"
  private_network_only = "${var.compute["private_network_only"]}"
  private_vlan_id      = "${ibm_compute_vm_instance.master.0.private_vlan_id}"     // notice this uses the master private_vlan_id
  ssh_key_ids          = ["${ibm_compute_ssh_key.ibm_public_key.id}"]
  tags                 = ["${var.compute_tag}"]

  connection {
    user               = "${var.ssh_user}"
    private_key        = "${tls_private_key.ssh.private_key_pem}"
    host               = "${self.ipv4_address}"
  }
  # copy local files to newly created VM
  provisioner "file" {
    source             = "${path.cwd}/${var.ssh_key_name}${local.priv}"
    destination        = "/tmp/id_rsa"
  }
  provisioner "file" {
    source             = "${path.cwd}/${var.ssh_key_name}${local.pub}"
    destination        = "/tmp/id_rsa.pub"
  }
  provisioner "file" {
    source             = "${path.module}/scripts/self_certs.sh"
    destination        = "/tmp/self_certs.sh"
  }
  provisioner "file" {
    source             = "${path.module}/scripts/add_os_user.sh"
    destination        = "/tmp/add_os_user.sh"
  }
  provisioner "file" {
    source             = "${path.module}/scripts/namehost.sh"
    destination        = "/tmp/namehost.sh"
  }
  provisioner "file" {
    source             = "${path.module}/scripts/initial_prep.sh"
    destination        = "/tmp/initial_prep.sh"
  }  

  provisioner "remote-exec" {
    inline             = [
      "chmod +x /tmp/namehost.sh; sudo /tmp/namehost.sh ${var.host_base} ${self.ipv4_address} ${var.host_io}",
      "chmod +x /tmp/initial_prep.sh; sudo /tmp/initial_prep.sh",
      "chmod +x /tmp/add_os_user.sh; sudo /tmp/add_os_user.sh ${var.os_user} ${var.os_password}",
      "chmod +x /tmp/self_certs.sh; sudo /tmp/self_certs.sh"
    ]
  }
}