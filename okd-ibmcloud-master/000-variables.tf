#--------------------------------------------------------------------------------------------------------
#---- Global variables that are available to all .tf files
#---- Variables listed in alpha order for ease of locating
#--------------------------------------------------------------------------------------------------------

variable "cloud_domain" {
  description = "Default domain that is added to the IBM Cloud VM machine, this is not the same as the OS domain."
  default = "okd.com"
}


variable "cluster_id" {
  description = "Default cluster name that will be used in the inventory.cfg file"  
  default = "mycluster"
}

variable "compute" {
  description = "Default VM configuration for a compute node"
  type = "map"

  default = {
    cpu_cores            = "8"
    disk_size            = "100"     // GB
    hourly_billing       = true
    local_disk           = true
    memory               = "16384"
    name                 = "compute"
    network_speed        = "100"
    nodes                = "3"
    private_network_only = false
  }
}
variable "compute_tag" {
  description = "Default tag for compute node"
  default = ["okd","compute"]
}

variable datacenter {
  description = "IBM datacenter code"
  default = ""
}

variable "host_base" {
  description = "Starting value to be used when creating the OS hostname and second portion of system name in the /etc/hosts entry"
  default = "okd"
}

variable "host_tail" {
  description = "Ending value that is used when creating the system name in the /etc/hosts entry"
  default = "sys"
}

variable "host_io" {
  description = "Used when creating the hostname to provide public DNS support.  Valid values are nip.io or xip.io"
  default = "nip.io"
}

variable ibm_api_key {
  description = "IBM Cloud Infrastructure Password"
  default     = "user must provide, or error will occur"
}

variable ibm_api_username {
  description = "IBM Cloud Infrastructure Username"
  default     = "user must provide, or error will occur"
}

variable "master" {
  description = "Default VM configuration for a Master node"
  type = "map"

  default = {
    cpu_cores            = "16"
    disk_size            = "100"     // GB
    hourly_billing       = true
    local_disk           = true
    memory               = "32768"
    name                 = "master"
    network_speed        = "100"
    nodes                = "1"
    private_network_only = false
  }
}

variable "master_tag" {
  description = "Default tag for master node"
  default = ["okd","master"]
}

variable okd_password {
  description = "Password for the user that will be defined to access the OKD cluster.  Use this parameter in conjunction with the okd_user parameter."
  default = "admin"
}
variable okd_user {
  description = "The user name that will be defined to access the OKD cluster. Use this parameter in conjunction with the okd_password parameter. "
  default = "admin"
}
variable okd_version {
  description = "Version of OKD software to install.  Valid values are 3.10 or 3.11 "
  default = "3.11"
}
variable os_password {
  description = "The password for the optional OS system user defined by the os_user variable"
  default = ""
}

variable "os_reference" {
  description = "DO NOT CHANGE. This is the IBM Cloud OS Reference Code for Centos.  This defines the CentOS operating system that is installed on the newly created virtual machines."
  default = "CENTOS_7_64"
}

variable os_user {
  description = "Optional OS system user to be defined. Use with os_password variable"
  default = ""
}

#variable "sl_domain" {
#  description = "Domain that is appended to SoftLayer device"
#  default     = "okd.com"
#}


variable ssh_key_name {
  description = "SSH Public Key Label and name of file created for the generated SSH key"
  default = "sshkey"
}

variable "ssh_user" {
  description = "SSH User"
  default     = "root"
}

variable "storage_space" {
  description = "GB of storage to request"
  default = "20"
}

