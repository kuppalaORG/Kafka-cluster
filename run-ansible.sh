#!/bin/bash

echo "📦 Fetching broker DNS from Terraform..."
BROKER_DNS=$(terraform output -json broker_dns_names | jq -r '.[]')
echo "🔍 Broker DNS names:"
echo "$BROKER_DNS"

# Step 1: Clone or update Ansible repo
ANSIBLE_DIR="/tmp/kafka-ansible-setup"
if [ ! -d "$ANSIBLE_DIR" ]; then
  echo "📥 Cloning Ansible repo..."
  git clone https://github.com/kuppalaORG/kafka-installation-ansible.git $ANSIBLE_DIR
else
  echo "🔁 Repo exists. Pulling latest..."
  cd $ANSIBLE_DIR && git pull
fi

# Step 2: Build dynamic inventory file
echo "📄 Creating dynamic inventory..."
INVENTORY_FILE="/tmp/kafka-inventory.ini"
echo "[all]" > $INVENTORY_FILE
for dns in $BROKER_DNS; do
  echo "$dns ansible_user=ec2-user ansible_ssh_private_key_file=/home/grunner/.ssh/kafka-key.pem" >> $INVENTORY_FILE
done

echo "📂 Inventory contents:"
cat $INVENTORY_FILE

# Step 3: Ping test
echo "🔧 Verifying SSH access with Ansible ping..."
ansible all -i $INVENTORY_FILE -m ping

# Step 4: Run playbook
echo "🚀 Running install-kafka.yml playbook..."
cd $ANSIBLE_DIR || exit 1
ansible-playbook -i $INVENTORY_FILE install-kafka.yml
