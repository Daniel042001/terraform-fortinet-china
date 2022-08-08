locals {
  nameSgFgtPublic  = "sg_fgt_public"
  nameSgFgtPrivate = "sg_fgt_private"
}

resource "aws_security_group" "sgFgtPublic" {
  name        = local.nameSgFgtPublic
  description = "FortiGate public facing security group"
  vpc_id      = aws_vpc.vpcNgfw.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "VPN-IKE"
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "VPN-NATT"
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
  }

  tags = {
    Name      = local.nameSgFgtPublic
    Terraform = "true"
  }
}


resource "aws_security_group" "sgFgtPrivate" {
  name        = local.nameSgFgtPrivate
  description = "FortiGate Private facing security group"
  vpc_id      = aws_vpc.vpcNgfw.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = local.nameSgFgtPrivate
    Terraform = "true"
  }
}
