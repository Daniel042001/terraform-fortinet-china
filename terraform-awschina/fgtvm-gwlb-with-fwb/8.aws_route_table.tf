locals {
  nameRtbEdgeAssociation = "rtb-igw"
  prefixRtbNatgw         = "rtb-natgw"
  prefixRtbNlbPublic     = "rtb-nlb-public"
  prefixRtbGwlbeNgfw     = "rtb-gwlbe-ngfw"
  prefixRtbNvaMgmt       = "rtb-nva-mgmt"
  prefixRtbApp           = "rtb-app"
}

locals {
  idIgwVpcNgfw = var.enableNewVpcNgfw == true ? aws_internet_gateway.vpcNgfwIgw[0].id : var.paramIgwId
}

#################### Route Table: Egde Association ####################
resource "aws_route_table" "rtbEdgeAssociation" {
  vpc_id = local.idVpcNgfw

  dynamic "route" {
    for_each = var.azList
    content {
      cidr_block      = var.cidrSubnetNlbPublic[route.key]
      vpc_endpoint_id = aws_vpc_endpoint.gwlbeVpcNgfw[route.key].id
    }
  }

  dynamic "route" {
    for_each = var.azList
    content {
      cidr_block      = var.cidrSubnetNatgwVpcNgfw[route.key]
      vpc_endpoint_id = aws_vpc_endpoint.gwlbeVpcNgfw[route.key].id
    }
  }

  dynamic "route" {
    for_each = var.enableDemoBastion == true ? [1] : []
    content {
      cidr_block      = var.cidrSubnetBastionVncAz1
      vpc_endpoint_id = aws_vpc_endpoint.gwlbeVpcNgfw[0].id
    }
  }

  tags = {
    Name      = local.nameRtbEdgeAssociation
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_route_table_association" "associateVpc1Igw" {
  gateway_id     = local.idIgwVpcNgfw
  route_table_id = aws_route_table.rtbEdgeAssociation.id
}



#################### Route Table: Nat Gateway ####################
resource "aws_route_table" "rtbNatgw" {
  count = length(var.azList)

  vpc_id = local.idVpcNgfw

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.gwlbeVpcNgfw[count.index].id
  }

  tags = {
    Name      = "${local.prefixRtbNatgw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_route_table_association" "associateSubnetNatgw" {
  count          = length(var.azList)
  subnet_id      = aws_subnet.subnetNatgwVpcNgfw[count.index].id
  route_table_id = aws_route_table.rtbNatgw[count.index].id
}



################### Route Table: NLB-Public ####################
resource "aws_route_table" "rtbNlbPublic" {
  count = length(var.azList)

  vpc_id = local.idVpcNgfw

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.gwlbeVpcNgfw[count.index].id
  }

  tags = {
    Name      = "${local.prefixRtbNlbPublic}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_route_table_association" "associateSubnetNlbPublic" {
  count          = length(var.azList)
  subnet_id      = aws_subnet.subnetNlbPublic[count.index].id
  route_table_id = aws_route_table.rtbNlbPublic[count.index].id
}



#################### Route Table: GWLBE-VPC-NGFW ####################
resource "aws_route_table" "rtbGwlbeNgfw" {
  vpc_id = local.idVpcNgfw

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.idIgwVpcNgfw
  }

  tags = {
    Name      = local.prefixRtbGwlbeNgfw
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_route_table_association" "associateSubnetGwlbeNgfw" {
  count          = length(var.azList)
  subnet_id      = aws_subnet.subnetGwlbeNgfw[count.index].id
  route_table_id = aws_route_table.rtbGwlbeNgfw.id
}



#################### Route Table: Network Virtual Appliance (NVA) Mgmt ####################
resource "aws_route_table" "rtbNvaMgmt" {
  count = var.enableDemoBastion == true ? length(var.azList) : 1

  vpc_id = local.idVpcNgfw

  dynamic "route" {
    for_each = var.enableDemoBastion == true ? [] : [1]
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = local.idIgwVpcNgfw
    }
  }

  dynamic "route" {
    for_each = var.enableDemoBastion == true ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.natgwVpcNgfw[count.index].id
    }
  }

  tags = {
    Name      = "${local.prefixRtbNvaMgmt}${var.enableDemoBastion == true ? "-" : ""}${var.enableDemoBastion == true ? local.azFtntList[count.index] : ""}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_route_table_association" "associateSubnetFgtPort1" {
  count          = length(var.azList)
  subnet_id      = aws_subnet.subnetFgtPort1[count.index].id
  route_table_id = var.enableDemoBastion == true ? aws_route_table.rtbNvaMgmt[count.index].id : aws_route_table.rtbNvaMgmt[0].id
}

resource "aws_route_table_association" "associateSubnetFwbPort1" {
  count          = length(var.azList)
  subnet_id      = aws_subnet.subnetFwbPort1[count.index].id
  route_table_id = var.enableDemoBastion == true ? aws_route_table.rtbNvaMgmt[count.index].id : aws_route_table.rtbNvaMgmt[0].id
}



#################### Route Table: APP ####################
resource "aws_route_table" "rtbApp" {
  count = var.enableSimpleWebSrv == false && var.enableDemoDvwa == false ? 0 : length(var.azList)

  vpc_id = local.idVpcNgfw

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgwVpcNgfw[count.index].id
  }

  tags = {
    Name      = "${local.prefixRtbApp}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_route_table_association" "subnetAppAssociate" {
  count          = var.enableSimpleWebSrv == false && var.enableDemoDvwa == false ? 0 : length(var.azList)
  subnet_id      = aws_subnet.subnetApp[count.index].id
  route_table_id = aws_route_table.rtbApp[count.index].id
}


