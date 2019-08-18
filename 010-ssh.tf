#--------------------------------------------------------------------------------------------------------
#---- SSH key related
#--------------------------------------------------------------------------------------------------------
#---- Define constaints that are appended to ssh file names when the files are copied.
locals {
  pub = ".pub"
  priv = ".priv"
}

#---- Create private key using RSA algo
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  #---- Create key and write to local file
  provisioner "local-exec" {
    command = "cat > ${var.ssh_key_name} <<EOL\n${tls_private_key.ssh.private_key_pem}\nEOL"
  }
  # copy private key to local file named {ssh_key_name}.priv
  provisioner "local-exec" {
    command = "cp ${var.ssh_key_name} ${var.ssh_key_name}${local.priv}"
  }
  # save public key to {name}.pub
  provisioner "local-exec" {
    command = "cat > ${var.ssh_key_name}${local.pub} <<EOL\n${tls_private_key.ssh.public_key_openssh}\nEOL"
  }
  #---- Change privledges of key file
  provisioner "local-exec" {
    command = "chmod 600 ${var.ssh_key_name}"
  }
}

#---- Use the newly created private key as IBM Cloud SSH key
resource "ibm_compute_ssh_key" "ibm_public_key" {
  label       = "${var.ssh_key_name}"
  public_key  = "${tls_private_key.ssh.public_key_openssh}"
}

