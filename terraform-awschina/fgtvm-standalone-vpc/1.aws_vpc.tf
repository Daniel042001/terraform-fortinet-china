#################### VPC ####################
resource "aws_vpc" "vpcNgfw" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = var.cidrVpcNgfw
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name      = var.vpcName
    Terraform = true
  }

  tags_all = {
    Name = var.vpcName
  }
}

