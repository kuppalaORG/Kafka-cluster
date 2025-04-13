output "public_ips" {
  value = aws_instance.kafka[*].public_ip
}

output "private_ips" {
  value = aws_instance.kafka[*].private_ip
}
