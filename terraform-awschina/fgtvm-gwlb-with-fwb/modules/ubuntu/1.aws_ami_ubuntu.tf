locals {
  nameUbuntu = {
    bionic1804 = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
    focal2004  = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    jammy2204  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [local.nameUbuntu[var.versionUbuntu]]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = var.regionName == "cn-north-1" || var.regionName == "cn-northwest-1" ? ["837727238323"] : ["099720109477"] # Canonical
}
