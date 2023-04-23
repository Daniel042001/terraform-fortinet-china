locals {
  nameSgFgtPort1 = "sg_fgt_public"
  nameSgFgtPort2 = "sg_fgt_private"
  nameSgFwbPort1 = "sg_fwb_public"
}

locals {
  onlyVpcNgfwCidr = var.enableDemoBastion == true && var.enableNlbPreserveClientIp == false ? true : false
}

resource "aws_security_group" "sgFgtPort1" {
  name        = local.nameSgFgtPort1
  description = local.nameSgFgtPort1
  vpc_id      = local.idVpcNgfw

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.enableDemoBastion == true ? [var.cidrVpcNgfw] : ["0.0.0.0/0"]
    description = "ping"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.enableDemoBastion == true ? [var.cidrVpcNgfw] : ["0.0.0.0/0"]
    description = ""
  }

  ingress {
    description = "FGTHTTPS"
    from_port   = var.portFgtHttps
    to_port     = var.portFgtHttps
    protocol    = "tcp"
    cidr_blocks = var.enableDemoBastion == true ? [var.cidrVpcNgfw] : ["0.0.0.0/0"]
  }

  tags = {
    Name      = local.nameSgFgtPort1
    Terraform = true
    Project   = var.ProjectName
  }
}



resource "aws_security_group" "sgFgtPort2" {
  name        = local.nameSgFgtPort2
  description = local.nameSgFgtPort2
  vpc_id      = local.idVpcNgfw

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = local.nameSgFgtPort2
    Terraform = true
    Project   = var.ProjectName
  }
}



resource "aws_security_group" "sgFwbPort1" {
  name        = local.nameSgFwbPort1
  description = local.nameSgFwbPort1
  vpc_id      = local.idVpcNgfw

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.enableDemoBastion == true ? [var.cidrVpcNgfw] : ["0.0.0.0/0"]
    description = "ping"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.enableDemoBastion == true ? [var.cidrVpcNgfw] : ["0.0.0.0/0"]
    description = ""
  }

  ingress {
    description = "FWB-ADMIN-HTTPS"
    from_port   = var.portFwbHttps
    to_port     = var.portFwbHttps
    protocol    = "tcp"
    cidr_blocks = var.enableDemoBastion == true ? [var.cidrVpcNgfw] : ["0.0.0.0/0"]
  }

  ingress {
    description = "FWB-TRAFFIC-HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.onlyVpcNgfwCidr == true ? [var.cidrVpcNgfw] : ["0.0.0.0/0"]
  }

  ingress {
    description = "FWB-TRAFFIC-HTTP"
    from_port   = var.portsNlb.portFwbListener
    to_port     = var.portsNlb.portFwbListener
    protocol    = "tcp"
    cidr_blocks = local.onlyVpcNgfwCidr == true ? [var.cidrVpcNgfw] : ["0.0.0.0/0"]
  }

  tags = {
    Name      = local.nameSgFwbPort1
    Terraform = true
    Project   = var.ProjectName
  }
}




