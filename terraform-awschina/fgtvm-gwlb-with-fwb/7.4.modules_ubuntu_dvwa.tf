module "ubuntu-dvwa" {
  source = "./modules/ubuntu"
  depends_on = [
    module.fortigate-byol,
    module.fortigate-payg,
    aws_lb.gwlbFgt,
    aws_nat_gateway.natgwVpcNgfw
  ]

  cntUbuntu  = var.enableDemoDvwa == true ? 1 : 0
  nameUbuntu = "dvwa"
  public     = false

  instanceTypeUbuntu  = "t3.micro"
  cloudInitScriptPath = "../../bootstrap-scripts/bootstrap_ubuntu_dvwa_apache2.sh"

  ProjectName   = var.ProjectName
  CompanyName   = var.CompanyName
  regionName    = var.regionName
  azList        = var.azList
  vpcId         = local.idVpcNgfw
  keynameUbuntu = var.keynameUbuntu
  versionUbuntu = var.versionUbuntu
  subnetUbuntu  = [for subnet in aws_subnet.subnetApp : subnet.id]
  sgUbuntu      = var.enableDemoDvwa == true ? aws_security_group.sgDvwa[0].id : null
  password      = ""
}



locals {
  nameSgDvwa = "sg_dvwa"
}



resource "aws_security_group" "sgDvwa" {
  count = var.enableDemoDvwa == true ? 1 : 0

  name        = local.nameSgDvwa
  description = local.nameSgDvwa
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
    Name      = local.nameSgDvwa
    Terraform = true
    Project   = var.ProjectName
  }
}
