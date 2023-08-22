locals {
  prefixEipFgtMgmt  = "eip-fgt-mgmt"
  prefixEniFgtPort1 = "eni-fgt-port1"
  prefixEniFgtPort2 = "eni-fgt-port2"
}

locals {
  azFtntList = [for az in var.azList : "${var.regionName}${az}"]
}

locals {
  cntFgt = var.licenseTypeFgt == "byol" ? var.cntFgtByol > length(var.licenseFiles) ? length(var.licenseFiles) : var.cntFgtByol : var.cntFgtPayg
}

locals {
  cntFgtStart = var.licenseTypeFgt == "byol" ? 1 : var.cntFgtByol + 1
}

resource "aws_instance" "fortigate" {
  count = local.cntFgt

  ami = data.aws_ami.fortigate.id

  instance_type     = var.instanceTypeFgtFixed
  availability_zone = local.azFtntList[count.index % length(var.azList)]
  user_data = templatefile(var.instanceBootstrapFgt,
    {
      enablePrimary    = (count.index == 0 && var.cntFgtByol != 0 && var.licenseTypeFgt == "byol") || (count.index == 0 && var.cntFgtByol == 0 && var.licenseTypeFgt == "payg") ? true : false
      versionFgt       = var.licenseTypeFgt == "payg" && local.nameAwsLocation == "CHINA" ? "7.2.0" : var.versionFgt
      licenseTypeFgt   = var.licenseTypeFgt
      licenseFile      = var.licenseTypeFgt == "byol" ? var.licenseFiles[count.index] : null
      portFgtHttps     = var.portFgtHttps
      fgtConfHostname  = "FG-${var.CompanyName}-${count.index + local.cntFgtStart}"
      numberOfAz       = length(var.azList)
      ipAddrGwlbAz1    = var.ipAddrEniGwlbAz1
      ipAddrGwlbAz2    = var.ipAddrEniGwlbAz2
      ipAddrGwlbAz3    = var.ipAddrEniGwlbAz3
      enableAz2        = length(var.azList) == 1 ? false : true
      enableAz3        = length(var.azList) == 3 ? true : false
      asgFgtClusterPSK = var.asgFgtClusterPSK

      # The first FortiGate in the first selected AZ, is designated as the Primary FortiGate.
      # 'var.ipAddrFgtStart' is the first ip assigned to FortiGate port1 in the subnet of the first AZ.
      ipAddrClusterPrimary = cidrhost(var.cidrSubnetFgtPort1[0], var.ipAddrFgtStart)
    }
  )

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
    network_interface_id = aws_network_interface.eniFgtPort1[count.index].id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.eniFgtPort2[count.index].id
    device_index         = 1
  }

  tags = {
    Name      = "FG-${var.CompanyName}-${count.index + local.cntFgtStart}"
    Terraform = true
    Project   = var.ProjectName
  }
}



#################### EIP: MGMT ####################
resource "aws_eip" "eipFgtMgmt" {
  count = var.enableDemoBastion == true ? 0 : local.cntFgt

  depends_on = [aws_network_interface.eniFgtPort1]
  domain     = "vpc"

  tags = {
    Name      = "${local.prefixEipFgtMgmt}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + local.cntFgtStart}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_eip_association" "eipAssocFgtMgmt" {
  count = var.enableDemoBastion == true ? 0 : local.cntFgt

  depends_on = [
    aws_network_interface.eniFgtPort1
  ]
  network_interface_id = aws_network_interface.eniFgtPort1[count.index].id
  allocation_id        = aws_eip.eipFgtMgmt[count.index].id
}



#################### FGT port1 ####################
resource "aws_network_interface" "eniFgtPort1" {
  count = local.cntFgt

  description = "${local.prefixEniFgtPort1}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + local.cntFgtStart}"
  subnet_id   = var.subnetFgtPort1[count.index % length(var.azList)]
  private_ips = [var.ipAddrFgtPort1List[count.index]]



  tags = {
    Name      = "${local.prefixEniFgtPort1}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + local.cntFgtStart}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_network_interface_sg_attachment" "sgFgtPort1AttachEniFgtPort1" {
  count = local.cntFgt

  depends_on           = [aws_network_interface.eniFgtPort1]
  security_group_id    = var.sgFgtPort1
  network_interface_id = aws_network_interface.eniFgtPort1[count.index].id
}



#################### FGT port2 ####################
resource "aws_network_interface" "eniFgtPort2" {
  count = local.cntFgt

  description       = "${local.prefixEniFgtPort2}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + local.cntFgtStart}"
  subnet_id         = var.subnetFgtPort2[count.index % length(var.azList)]
  private_ips       = [var.ipAddrFgtPort2List[count.index]]
  source_dest_check = false

  tags = {
    Name      = "${local.prefixEniFgtPort2}-${local.azFtntList[count.index % length(var.azList)]}-${count.index + local.cntFgtStart}"
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "aws_network_interface_sg_attachment" "sgFgtPort2AttachEniFgtPort2" {
  count = local.cntFgt

  depends_on           = [aws_network_interface.eniFgtPort2]
  security_group_id    = var.sgFgtPort2
  network_interface_id = aws_network_interface.eniFgtPort2[count.index].id
}

