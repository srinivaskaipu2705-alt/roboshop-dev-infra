#!/bin/bash

component=$1
environment=$2
dnf install ansible -y
# ansible-pull -U https://github.com/srinivaskaipu2705-alt/ansible-roboshop-roles-tf.git -e component=${component} main.yaml
# git clone ansble-playbooks
# cd ansble-playbooks
#ansible-playbook -i inventory maoin.yaml
# ansible-pull -U

# This script is used to bootstrap the databases module of the roboshop-dev-infra Terraform code. It is executed by Terraform as a provisioner after the database instances are created.
REPO_URL=https://github.com/srinivaskaipu2705-alt/ansible-roboshop-roles-tf.git
REPO_DIR=/opt/roboshop/ansible
ANSIBLE_DIR=ansible-roboshop-roles-tf

# Install Ansible
mkdir -p $REPO_DIR
mkdir -p /var/log/roboshop/
touch /var/log/roboshop/ansible.log

#go to the base directory where the repository will be cloned
cd $REPO_DIR

# check if the repository is already cloned
if [ ! -d "$ANSIBLE_DIR" ]; then
  git clone $REPO_URL
else
  echo "Repository already exists. Pulling latest changes."
  cd $ANSIBLE_DIR
  git pull origin main
  cd .. # go back to the base directory
fi

#enter the sepcific repo folder befor running the playbook
cd $ANSIBLE_DIR

# Run the Ansible playbook
ansible-playbook -e component=${component} -e env=${environment} main.yaml