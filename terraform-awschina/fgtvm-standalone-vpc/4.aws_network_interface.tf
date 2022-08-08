locals {
  nameEniFgtPublic  = "eni-fgt-public"
  nameEniFgtPrivate = "eni-fgt-private"
}


resource "aws_network_interface" "eniFgtPublic" {
  description        = local.nameEniFgtPublic
  ipv4_prefix_count  = "0"
  ipv6_address_count = "0"
  ipv6_prefix_count  = "0"
  private_ips        = [var.eniIpFgtPublic]
  security_groups    = [aws_security_group.sgFgtPublic.id]
  source_dest_check  = true
  subnet_id          = aws_subnet.subnetPublic.id

  tags = {
    Name      = local.nameEniFgtPublic
    Terraform = true
  }
}

resource "aws_network_interface" "eniFgtPrivate" {
  description        = local.nameEniFgtPrivate
  ipv4_prefix_count  = "0"
  ipv6_address_count = "0"
  ipv6_prefix_count  = "0"
  private_ips        = [var.eniIpFgtPrivate]
  security_groups    = [aws_security_group.sgFgtPrivate.id]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnetPrivate.id

  tags = {
    Name      = local.nameEniFgtPrivate
    Terraform = true
  }
}
