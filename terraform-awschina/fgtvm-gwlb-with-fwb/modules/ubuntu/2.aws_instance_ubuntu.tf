locals {
  prefixEipUbuntu = "eip-${var.nameUbuntu}"
  prefixEniUbuntu = "eni-${var.nameUbuntu}"
}

locals {
  azFtntList = [for az in var.azList : "${var.regionName}${az}"]
}

resource "aws_instance" "ubuntu" {
  count = var.cntUbuntu

  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instanceTypeUbuntu
  availability_zone = local.azFtntList[count.index % length(var.azList)]
  key_name          = var.keynameUbuntu

  user_data = var.cloudInitScriptPath == "" ? "" : templatefile(var.cloudInitScriptPath,
    {
      versionUbuntu = var.versionUbuntu
      password      = var.password
    }
  )

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    volume_size           = "20"
    volume_type           = "gp2"
  }

  network_interface {
    network_interface_id = aws_network_interface.eniUbuntu[count.index].id
    device_index         = 0
  }

  tags = {
    Name      = "${var.nameUbuntu}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + 1}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### UBUNTU EIP ####################
resource "aws_eip" "eipUbuntu" {
  count = var.public == true ? var.cntUbuntu : 0

  depends_on        = [aws_network_interface.eniUbuntu]
  domain            = "vpc"
  network_interface = aws_network_interface.eniUbuntu[count.index].id

  tags = {
    Name      = "${local.prefixEipUbuntu}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + 1}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### UBUNTU ETH0 ####################
resource "aws_network_interface" "eniUbuntu" {
  count = var.cntUbuntu

  description = "${local.prefixEniUbuntu}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + 1}"
  subnet_id   = var.subnetUbuntu[count.index % length(var.azList)]

  tags = {
    Name      = "${local.prefixEniUbuntu}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + 1}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_network_interface_sg_attachment" "attachSgToEniUbuntu" {
  count = var.cntUbuntu

  depends_on           = [aws_network_interface.eniUbuntu]
  security_group_id    = var.sgUbuntu
  network_interface_id = aws_network_interface.eniUbuntu[count.index].id
}
