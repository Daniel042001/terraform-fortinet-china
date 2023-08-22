locals {
  prefixNatgwVpcNgfw    = "natgw"
  prefixEipNatgwVpcNgfw = "eip-natgw"
}

resource "aws_eip" "eipNatgwVpcNgfw" {
  count = var.enableFgStandalone == true ? 0 : length(var.azList)

  domain = "vpc"

  tags = {
    Name      = "${local.prefixEipNatgwVpcNgfw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_nat_gateway" "natgwVpcNgfw" {
  count = var.enableFgStandalone == true ? 0 : length(var.azList)

  allocation_id     = aws_eip.eipNatgwVpcNgfw[count.index].id
  connectivity_type = "public"
  subnet_id         = aws_subnet.subnetNatgwVpcNgfw[count.index].id

  tags = {
    Name      = "${local.prefixNatgwVpcNgfw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}
