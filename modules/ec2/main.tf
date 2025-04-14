resource "aws_instance" "kafka" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index)
  key_name      = var.key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]

  tags = {
    Name = "${var.name_prefix}-broker-${count.index + 1}"
  }
}
resource "aws_route53_record" "kafka_broker" {
  count   = var.route53_zone_id != null && var.domain_name != null ? var.instance_count : 0
  zone_id = var.route53_zone_id
  name    = "kafka-broker-${count.index + 1}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.kafka[count.index].public_ip]

  depends_on = [aws_instance.kafka]
}
