#!/bin/bash

# Step 1: Get broker DNS from Terraform
echo "🔍 Getting broker DNS from Terraform..."
BROKER_DNS=$(terraform output -json broker_dns_names | jq -r '.[]')

echo "🔁 Pulling latest Ansible repo..."
if [ ! -d "/tmp/kafka-ansible-setup" ]; then
  git clone https://github.com/kuppalaORG/kafka-installation-ansible.git /tmp/kafka-ansible-setup
else
  cd /tmp/kafka-ansible-setup && git pull
fi

echo "📂 Checking ~/.ssh permissions..."
ls -l ~/.ssh

# Step 2: Build dynamic inventory
INVENTORY_FILE="/tmp/kafka-inventory.ini"
echo "[all]" > $INVENTORY_FILE
for dns in $BROKER_DNS; do
  echo "$dns ansible_user=ec2-user ansible_ssh_private_key_file=/home/grunner/.ssh/kafka-key.pem" >> $INVENTORY_FILE
done

# Step 3: Run Ansible playbook and capture logs
echo "🚀 Running Ansible playbook..."
cd /tmp/kafka-ansible-setup || exit 1

# Use tee to stream and save logs
ansible-playbook -i "$INVENTORY_FILE" install-kafka.yaml | tee /tmp/ansible-run.log
