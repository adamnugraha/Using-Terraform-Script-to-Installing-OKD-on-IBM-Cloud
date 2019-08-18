
//  Collect together all of the output variables needed to build to the final
//  inventory.cfg file from the inventory template.
data "template_file" "inventory" {
  template = "${file("${path.cwd}/templates/inventory.template.cfg")}"
  vars {
    public_hostname  = "${var.host_base}.${ibm_compute_vm_instance.master.0.ipv4_address}.${var.host_io}"
    master_inventory = "${var.host_base}.${ibm_compute_vm_instance.master.0.ipv4_address}.${var.host_io}"
    master_hostname  = "${var.host_base}.${ibm_compute_vm_instance.master.0.ipv4_address}.${var.host_io}"
    node1_hostname   = "${var.host_base}.${ibm_compute_vm_instance.compute.0.ipv4_address}.${var.host_io}"
    node2_hostname   = "${var.host_base}.${ibm_compute_vm_instance.compute.1.ipv4_address}.${var.host_io}"
    master_ip        = "${ibm_compute_vm_instance.master.0.ipv4_address}"
    node1_ip         = "${ibm_compute_vm_instance.compute.0.ipv4_address}"
    node2_ip         = "${ibm_compute_vm_instance.compute.1.ipv4_address}"
    node3_ip         = "${ibm_compute_vm_instance.compute.2.ipv4_address}"
    cluster_id       = "${var.cluster_id}"
    version          = "${var.okd_version}"
  }
}
