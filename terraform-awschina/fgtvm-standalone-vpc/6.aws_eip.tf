locals {
  nameEipFgt = "eip-fgt"
}

resource "aws_eip" "eipFgt" {
  vpc               = true
  network_interface = aws_network_interface.eniFgtPublic.id
  depends_on        = [aws_internet_gateway.vpcNgfwIgw]

  tags = {
    Name      = local.nameEipFgt
    Terraform = true
  }
}


