output "security_group_id" {
  value = aws_security_group.kafka_sg.id
}

output "security_group_name" {
  value = aws_security_group.kafka_sg.name
}

output "security_group_vpc_id" {
  value = aws_security_group.kafka_sg.vpc_id
}

output "security_group_ingress_rules" {
  value = aws_security_group.kafka_sg.ingress
}

output "security_group_egress_rules" {
  value = aws_security_group.kafka_sg.egress
}
