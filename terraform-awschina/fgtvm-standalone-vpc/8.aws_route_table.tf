#################### Route Table DEFINITION ####################
resource "aws_route_table" "rtbFgtPublic" {
  vpc_id = aws_vpc.vpcNgfw.id

  tags = {
    Name      = "RouteTable of FGT Public Subnet"
    Terraform = true
  }
}

resource "aws_route_table" "rtbFgtPrivate" {
  vpc_id = aws_vpc.vpcNgfw.id

  tags = {
    Name      = "RouteTable of FGT Private Subnet"
    Terraform = true
  }
}



#################### Route Table Association DEFINITION ####################
resource "aws_route_table_association" "subnetPublicAssociate" {
  subnet_id      = aws_subnet.subnetPublic.id
  route_table_id = aws_route_table.rtbFgtPublic.id
}

resource "aws_route_table_association" "subnetPrivateAssociate" {
  subnet_id      = aws_subnet.subnetPrivate.id
  route_table_id = aws_route_table.rtbFgtPrivate.id
}



#################### UDR(User Defined Routes) DEFINITION ####################
resource "aws_route" "externalRoute" {
  route_table_id         = aws_route_table.rtbFgtPublic.id
  gateway_id             = aws_internet_gateway.vpcNgfwIgw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "internalRoute" {
  depends_on             = [aws_instance.fgtStandalone]
  route_table_id         = aws_route_table.rtbFgtPrivate.id
  network_interface_id   = aws_network_interface.eniFgtPrivate.id
  destination_cidr_block = "0.0.0.0/0"
}
