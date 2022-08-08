#################### Subnet Primary ####################
resource "aws_subnet" "subnetPublic" {
  vpc_id            = aws_vpc.vpcNgfw.id
  cidr_block        = var.cidrSubnetPublic
  availability_zone = var.azFgt

  tags = {
    Name      = var.subnetPublicName
    Terraform = true
  }

  tags_all = {
    Name = var.subnetPublicName
  }
}

resource "aws_subnet" "subnetPrivate" {
  vpc_id            = aws_vpc.vpcNgfw.id
  cidr_block        = var.cidrSubnetPrivate
  availability_zone = var.azFgt

  tags = {
    Name      = var.subnetPrivateName
    Terraform = true
  }

  tags_all = {
    Name = var.subnetPrivateName
  }
}
