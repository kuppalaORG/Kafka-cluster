terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-igw"
  }

}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }

}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)
  subnet_id = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}