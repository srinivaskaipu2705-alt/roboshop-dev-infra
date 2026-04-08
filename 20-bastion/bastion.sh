#!/bin/bash

# This script is used to bootstrap the databases module of the roboshop-dev-infra Terraform code. It is executed by Terraform as a provisioner after the database instances are created.
 sudo yum install -y yum-utils
 sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
 sudo yum -y install terraform
 