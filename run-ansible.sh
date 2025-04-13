#!/bin/bash

# Step 0: Clone or pull latest Ansible repo
if [ ! -d "/tmp/kafka-ansible-setup" ]; then
  git clone https://github.com/kuppalaORG/kafka-installation-ansible.git /tmp/kafka-ansible-setup
else
  echo "🔁 Repo exists. Pulling latest changes..."
  cd /tmp/kafka-ansible-setup && git pull
fi

# Step 1: Get IPs from terraform output
BROKER_IPS=$(terraform output -json broker_public_ips | jq -r '.[]')

# Debug: Print available SSH keys
echo "📂 Listing files in ~/.ssh:"
ls -l ~/.ssh

# Step 2: Build dynamic inventory
INVENTORY_FILE="/tmp/kafka-inventory.ini"
echo "[all]" > $INVENTORY_FILE

for ip in $BROKER_IPS; do
  echo "🔗 Adding broker: $ip"
  echo "${ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/kafka-key.pem" >> $INVENTORY_FILE
done

# Step 3: Run Ansible
cd /tmp/kafka-ansible-setup || return 1
ansible-playbook -i $INVENTORY_FILE install-kafka.yml
