locals {
  prefixNatgwVpcNgfw    = "natgw"
  prefixEipNatgwVpcNgfw = "eip-natgw"
}

resource "aws_eip" "eipNatgwVpcNgfw" {
  count = length(var.azList)

  vpc = true

  tags = {
    Name      = "${local.prefixEipNatgwVpcNgfw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_nat_gateway" "natgwVpcNgfw" {
  count = length(var.azList)

  allocation_id     = aws_eip.eipNatgwVpcNgfw[count.index].id
  connectivity_type = "public"
  subnet_id         = aws_subnet.subnetNatgwVpcNgfw[count.index].id

  tags = {
    Name      = "${local.prefixNatgwVpcNgfw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}
