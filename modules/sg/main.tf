resource "aws_security_group" "kafka_sg" {
  name        = "${var.name_prefix}-sg"
  description = "Allow Kafka, Zookeeper, and SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    description = "Allow Kafka"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    description = "Allow Zookeeper"
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}
