output "route_table_id" {
  value = module.networking.route_table_id
}


output "security_group_id" {
  value = module.security_group.security_group_id
}
output "broker_public_ips" {
  value = module.ec2_brokers.public_ips
}

output "broker_private_ips" {
  value = module.ec2_brokers.private_ips
}

