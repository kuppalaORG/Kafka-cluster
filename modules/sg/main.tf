resource "aws_security_group" "kafka_sg" {
  name        = "${var.name_prefix}-sg"
  description = "Allow Kafka, Zookeeper, and SSH"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }
  ingress {
    description = "Allow Streamlit Dashboard"
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kafka client access
  ingress {
    description = "Allow Kafka"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  # Zookeeper client access
  ingress {
    description = "Allow Zookeeper client connections"
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  # ZooKeeper quorum sync (intra-broker)
  ingress {
    description = "Zookeeper quorum sync"
    from_port   = 2888
    to_port     = 2888
    protocol    = "tcp"
    self        = true
  }

  # ZooKeeper leader election (intra-broker)
  ingress {
    description = "Zookeeper leader election"
    from_port   = 3888
    to_port     = 3888
    protocol    = "tcp"
    self        = true
  }

  # Kafka inter-broker communication (optional if using multiple brokers)
  ingress {
    description = "Kafka inter-broker communication"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    self        = true
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
