module "ubuntu-bastion" {
  source = "./modules/ubuntu"
  depends_on = [
    module.fortigate-byol,
    module.fortigate-payg,
    aws_lb.gwlbFgt,
    aws_nat_gateway.natgwVpcNgfw
  ]

  cntUbuntu  = var.enableDemoBastion == true ? 1 : 0
  nameUbuntu = "bastion"
  public     = true

  instanceTypeUbuntu  = "c5.xlarge"
  cloudInitScriptPath = "../../bootstrap-scripts/bootstrap_ubuntu_bastion.sh"

  ProjectName   = var.ProjectName
  CompanyName   = var.CompanyName
  regionName    = var.regionName
  azList        = var.azList
  vpcId         = local.idVpcNgfw
  keynameUbuntu = var.keynameUbuntu
  versionUbuntu = var.versionUbuntu
  subnetUbuntu  = [for subnet in aws_subnet.subnetBastionVncAz1 : subnet.id]
  sgUbuntu      = var.enableDemoBastion == true ? aws_security_group.sgBastionVnc[0].id : null
  password      = "1qaz@WSX"
}



locals {
  prefixSubnetBastionVnc = "subnet-bastion-vnc"
  nameSgBastionVnc       = "sg_bastion_vnc"
  nameRtbBastionVnc      = "rtb-bastion-vnc"
}



#################### Bastion Server ####################
resource "aws_subnet" "subnetBastionVncAz1" {
  count = var.enableDemoBastion == true ? 1 : 0

  vpc_id            = local.idVpcNgfw
  cidr_block        = var.cidrSubnetBastionVncAz1
  availability_zone = local.azFtntList[0]

  tags = {
    Name      = local.prefixSubnetBastionVnc
    Terraform = true
    Project   = var.ProjectName
  }
}



resource "aws_security_group" "sgBastionVnc" {
  count = var.enableDemoBastion == true ? 1 : 0

  name        = local.nameSgBastionVnc
  description = local.nameSgBastionVnc
  vpc_id      = local.idVpcNgfw

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "VNC"
    from_port   = 5901
    to_port     = 5901
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = local.nameSgBastionVnc
    Terraform = true
    Project   = var.ProjectName
  }
}



resource "aws_route_table" "rtbBastionVnc" {
  count = var.enableDemoBastion == true ? 1 : 0

  vpc_id = local.idVpcNgfw

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgwVpcNgfw[0].id
  }

  tags = {
    Name      = local.nameRtbBastionVnc
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_route_table_association" "subnetBastionVncAssociate" {
  count          = var.enableDemoBastion == true ? 1 : 0
  subnet_id      = aws_subnet.subnetBastionVncAz1[0].id
  route_table_id = aws_route_table.rtbBastionVnc[0].id
}
