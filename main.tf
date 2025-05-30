module "vpc" {
  source     = "./modules/vpc"
  name       = "kafka-vpc"
  cidr_block = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {}

module "subnets" {
  source               = "./modules/subnet"
  vpc_id               = module.vpc.vpc_id
  name_prefix          = "kafka"
  availability_zones   = data.aws_availability_zones.available.names
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

module "networking" {
  source            = "./modules/route-table"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
  name_prefix       = "kafka"
}

module "security_group" {
  source        = "./modules/sg"
  vpc_id        = module.vpc.vpc_id
  name_prefix   = "kafka"
  allowed_cidrs = ["0.0.0.0/0"] # You can restrict this later
}

module "ec2_brokers" {
  source            = "./modules/ec2"
  ami_id            = var.ami_id
  instance_type     = "t3.large"
  instance_count    = 3
  subnet_ids        = module.subnets.public_subnet_ids
  security_group_id = module.security_group.security_group_id
  key_name          = var.key_name
  name_prefix       = "kafka"
  route53_zone_id     = var.route53_zone_id
  domain_name         = var.domain_name
}

resource "null_resource" "print_ips" {
  provisioner "local-exec" {
    command = "echo 'EC2 Public IPs: ${join(", ", module.ec2_brokers.public_ips)}'"
  }

  depends_on = [module.ec2_brokers]
}

resource "aws_route53_record" "dashboard_dns" {
  zone_id = var.route53_zone_id
  name    = "dashboard.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [element(module.ec2_brokers.public_ips, 0)]
}

# resource "null_resource" "run_ansible" {
#   provisioner "local-exec" {
#     command = "${path.module}/run-ansible.sh"
#   }
#
#   depends_on = [
#     module.ec2_brokers
#   ]
# }
