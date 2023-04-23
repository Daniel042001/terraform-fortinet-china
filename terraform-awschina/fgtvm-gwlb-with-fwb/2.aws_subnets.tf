locals {
  prefixSubnetFgtPort1     = "subnet-fgt-port1"
  prefixSubnetFgtPort2     = "subnet-fgt-port2"
  prefixSubnetFwbPort1     = "subnet-fwb-port1"
  prefixSubnetNlbPublic    = "subnet-nlb-public"
  prefixSubnetNatgwVpcNgfw = "subnet-natgw-vpcngfw"
  prefixSubnetGwlbeNgfw    = "subnet-gwlbe"
  prefixSubnetApp          = "subnet-app"
}

locals {
  idVpcNgfw = var.enableNewVpcNgfw == true ? aws_vpc.vpcNgfw[0].id : var.paramVpcCustomerId
}

locals {
  azFtntList = [for az in var.azList : "${var.regionName}${az}"]
}

#################### FortiGate ####################
resource "aws_subnet" "subnetFgtPort1" {
  count = length(var.azList)

  vpc_id            = local.idVpcNgfw
  cidr_block        = var.cidrSubnetFgtPort1[count.index]
  availability_zone = local.azFtntList[count.index]

  tags = {
    Name      = "${local.prefixSubnetFgtPort1}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_subnet" "subnetFgtPort2" {
  count = length(var.azList)

  vpc_id            = local.idVpcNgfw
  cidr_block        = var.cidrSubnetFgtPort2[count.index]
  availability_zone = local.azFtntList[count.index]

  tags = {
    Name      = "${local.prefixSubnetFgtPort2}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### FortiWeb ####################
resource "aws_subnet" "subnetFwbPort1" {
  count = length(var.azList)

  vpc_id            = local.idVpcNgfw
  cidr_block        = var.cidrSubnetFwbPort1[count.index]
  availability_zone = local.azFtntList[count.index]

  tags = {
    Name      = "${local.prefixSubnetFwbPort1}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### NAT Gateway ####################
resource "aws_subnet" "subnetNatgwVpcNgfw" {
  count = length(var.azList)

  vpc_id            = local.idVpcNgfw
  cidr_block        = var.cidrSubnetNatgwVpcNgfw[count.index]
  availability_zone = local.azFtntList[count.index]

  tags = {
    Name      = "${local.prefixSubnetNatgwVpcNgfw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### GWLB Endpoint ####################
resource "aws_subnet" "subnetGwlbeNgfw" {
  count = length(var.azList)

  vpc_id            = local.idVpcNgfw
  cidr_block        = var.cidrSubnetGwlbeNgfw[count.index]
  availability_zone = local.azFtntList[count.index]

  tags = {
    Name      = "${local.prefixSubnetGwlbeNgfw}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### NLB-Public ####################
resource "aws_subnet" "subnetNlbPublic" {
  count = length(var.azList)

  vpc_id            = local.idVpcNgfw
  cidr_block        = var.cidrSubnetNlbPublic[count.index]
  availability_zone = local.azFtntList[count.index]

  tags = {
    Name      = "${local.prefixSubnetNlbPublic}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### APP ####################
resource "aws_subnet" "subnetApp" {
  count = var.enableSimpleWebSrv == false && var.enableDemoDvwa == false ? 0 : length(var.azList)

  vpc_id            = local.idVpcNgfw
  cidr_block        = var.cidrSubnetApp[count.index]
  availability_zone = local.azFtntList[count.index]

  tags = {
    Name      = "${local.prefixSubnetApp}-${local.azFtntList[count.index]}"
    Terraform = true
    Project   = var.ProjectName
  }
}
