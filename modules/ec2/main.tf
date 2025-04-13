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
