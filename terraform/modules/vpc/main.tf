resource "aws_vpc" "nimbus_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nimbus_vpc.id
  tags = {
    Name = "${var.project}-igw"
  }
}


