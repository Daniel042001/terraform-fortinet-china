locals {
  prefixEipFwbMgmt  = "eip-fwb-mgmt"
  prefixEniFwbPort1 = "eni-fwb-port1"
}

locals {
  azFtntList = [for az in var.azList : "${var.regionName}${az}"]
}

locals {
  cntFwb = var.cntFwbByol
}

locals {
  cntFwbStart = var.licenseTypeFwb == "byol" ? 1 : var.cntFwbByol + 1
}

resource "aws_instance" "fortiweb" {
  count = local.cntFwb

  ami               = local.amiFwbByol[var.regionName]
  instance_type     = var.instanceTypeFwbFixed
  availability_zone = local.azFtntList[count.index % length(var.azList)]

  root_block_device {
    delete_on_termination = "true"
    volume_type           = "standard"
    volume_size           = "2"
  }

  ebs_block_device {
    delete_on_termination = "true"
    device_name           = "/dev/sdb"
    volume_size           = "40"
    volume_type           = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.eniFwbPort1[count.index].id
    device_index         = 0
  }

  tags = {
    Name      = "FWB-${var.CompanyName}-${count.index + local.cntFwbStart}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### EIP: MGMT ####################
resource "aws_eip" "eipFwbMgmt" {
  count = var.enableDemoBastion == true ? 0 : local.cntFwb

  depends_on = [aws_network_interface.eniFwbPort1]
  vpc        = true

  tags = {
    Name      = "${local.prefixEipFwbMgmt}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + local.cntFwbStart}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_eip_association" "eipAssocFwbPort1" {
  count = var.enableDemoBastion == true ? 0 : local.cntFwb

  depends_on = [
    aws_network_interface.eniFwbPort1
  ]
  network_interface_id = aws_network_interface.eniFwbPort1[count.index].id
  allocation_id        = aws_eip.eipFwbMgmt[count.index].id
}


#################### FWB port1 ####################
resource "aws_network_interface" "eniFwbPort1" {
  count = local.cntFwb

  description       = "${local.prefixEniFwbPort1}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + local.cntFwbStart}"
  subnet_id         = var.subnetFwbPort1[count.index % length(var.azList)]
  private_ips       = [var.ipAddrFwbPort1List[count.index]]
  source_dest_check = false

  tags = {
    Name      = "${local.prefixEniFwbPort1}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + local.cntFwbStart}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_network_interface_sg_attachment" "sgFwbPort1AttachEniFwbPort1" {
  count = local.cntFwb

  depends_on           = [aws_network_interface.eniFwbPort1]
  security_group_id    = var.sgFwbPort1
  network_interface_id = aws_network_interface.eniFwbPort1[count.index].id
}

