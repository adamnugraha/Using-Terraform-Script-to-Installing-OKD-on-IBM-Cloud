
<p align="center">
  <img src="./images/okdOnibm2.png?raw=true" alt="OKDinIBM" width="700" height="370">
</p>

<br>

## OKD in the IBM Cloud

#### Install files

This repository contains the installation files to install OKD in the IBM Cloud.

<br>

#### Documentation

Refer to this [site](https://pages.github.ibm.com/hc-coc/okd-docs/) for detailed documentation for installing OKD in the IBM Cloud:

#### Overview

A combination of terraform files and bash scripts perform the necessary tasks to provision virtual machines and install OKD in the IBM Cloud.  

#### User Notice

This installation requires the use of the Hashicorp Terraform program.  The "terraform" program is used from a terminal or command prompt.  

An IBM Cloud account is also required sinceJM this is the target cloud environmewnt.  Creation of the environment, virtual machine(s) along with installation of the OKD software will incur charges to your IBM Cloud account.

CentOS will be used for the operating system when the virtual machines are created.  The use of this operating system provides an open source and lower cost to deliver mechanism to assist in exploring Kubernetes orchistration.

