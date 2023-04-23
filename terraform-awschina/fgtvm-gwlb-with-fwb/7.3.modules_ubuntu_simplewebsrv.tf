module "ubuntu-simple-websrv" {
  source = "./modules/ubuntu"
  depends_on = [
    module.fortigate-byol,
    module.fortigate-payg,
    aws_lb.gwlbFgt,
    aws_nat_gateway.natgwVpcNgfw
  ]

  cntUbuntu  = var.enableSimpleWebSrv == true ? length(var.azList) : 0
  nameUbuntu = "websrv"
  public     = false

  instanceTypeUbuntu  = "t3.micro"
  cloudInitScriptPath = "../../bootstrap-scripts/bootstrap_ubuntu_nginx_simple_page.sh"

  ProjectName   = var.ProjectName
  CompanyName   = var.CompanyName
  regionName    = var.regionName
  azList        = var.azList
  vpcId         = local.idVpcNgfw
  keynameUbuntu = var.keynameUbuntu
  versionUbuntu = var.versionUbuntu
  subnetUbuntu  = [for subnet in aws_subnet.subnetApp : subnet.id]
  sgUbuntu      = var.enableSimpleWebSrv == true ? aws_security_group.sgWebSrv[0].id : null
  password      = ""
}



locals {
  nameSgWebSrv = "sg_simple_websrv"
}



resource "aws_security_group" "sgWebSrv" {
  count = var.enableSimpleWebSrv == true ? 1 : 0

  name        = local.nameSgWebSrv
  description = local.nameSgWebSrv
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
    cidr_blocks = [var.cidrVpcNgfw]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidrVpcNgfw]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidrVpcNgfw]
  }

  tags = {
    Name      = local.nameSgWebSrv
    Terraform = true
    Project   = var.ProjectName
  }
}
