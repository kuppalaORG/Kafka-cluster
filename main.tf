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