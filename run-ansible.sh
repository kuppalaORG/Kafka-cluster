#!/bin/bash

echo "🔁 Pulling latest Ansible repo..."

if [ ! -d "/tmp/kafka-ansible-setup" ]; then
  git clone https://github.com/kuppalaORG/kafka-installation-ansible.git /tmp/kafka-ansible-setup
else
  cd /tmp/kafka-ansible-setup && git pull
fi

echo "📂 Checking ~/.ssh permissions..."
ls -l ~/.ssh

echo "🚀 Running Ansible playbook..."
cd /tmp/kafka-ansible-setup || exit 1
ansible-playbook -i inventory/kafka-brokers.ini install-kafka.yaml
