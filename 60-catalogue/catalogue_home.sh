#!/bin/bash

# growing the /home volume to 50 GB as we will be installing terraform and ansible in the bastion host and also running ansible playbooks from the bastion host which may require more space for logs and other files. The default volume size is 8 GB which is not sufficient for our needs.
growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-homeVol
xfs_groefs /home

# This script is used to bootstrap the databases module of the roboshop-dev-infra Terraform code. It is executed by Terraform as a provisioner after the database instances are created.
 sudo yum install -y yum-utils
 sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
 sudo yum -y install terraform
