#!/bin/bash

echo "🔍 Checking Terraform outputs..."
terraform output -json broker_public_ips
echo "⚠️ Exit Code: $?"


# Step 0: Clone or pull latest Ansible repo
if [ ! -d "/tmp/kafka-ansible-setup" ]; then
  git clone https://github.com/kuppalaORG/kafka-installation-ansible.git /tmp/kafka-ansible-setup
else
  echo "🔁 Repo exists. Pulling latest changes..."
  cd /tmp/kafka-ansible-setup && git pull
fi


# Step 1: Get IPs from terraform output
BROKER_IPS=$(terraform output -json broker_public_ips | jq -r '.[]')
echo "📦 Broker IPs: $BROKER_IPS"
# Debug: Print available SSH keys
echo "📂 Listing files in ~/.ssh:"
ls -l ~/.ssh

# Step 2: Build dynamic inventory
# Step 2: Build dynamic inventory file
INVENTORY_FILE="/tmp/kafka-inventory.ini"
echo "[all]" > $INVENTORY_FILE

for ip in $BROKER_IPS; do
  echo "${ip} ansible_user=ec2-user ansible_ssh_private_key_file=/home/grunner/.ssh/kafka-key.pem" >> $INVENTORY_FILE
done

# Step 3: Run Ansible
cd /tmp/kafka-ansible-setup || exit 1
ansible-playbook -i $INVENTORY_FILE install-kafka.yml
