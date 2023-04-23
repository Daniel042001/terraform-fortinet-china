locals {
  # ipAddrFgtStart is the first ip assigned to FortiGate port1 in the subnet of the first AZ.
  ipAddrFgtStart = 11
}

locals {
  ipAddrFgtPort1ListByol = [
    for cnt in range(var.cntFgtByol) :
    cidrhost(var.cidrSubnetFgtPort1[cnt % length(var.azList)], (local.ipAddrFgtStart + cnt))
  ]
}

locals {
  ipAddrFgtPort2ListByol = [
    for cnt in range(var.cntFgtByol) :
    cidrhost(var.cidrSubnetFgtPort2[cnt % length(var.azList)], (local.ipAddrFgtStart + cnt))
  ]
}

module "fortigate-byol" {
  source               = "./modules/fortigate"
  ProjectName          = var.ProjectName
  CompanyName          = var.CompanyName
  enableDemoBastion    = var.enableDemoBastion
  regionName           = var.regionName
  azList               = var.azList
  cidrSubnetFgtPort1   = var.cidrSubnetFgtPort1
  cidrSubnetFgtPort2   = var.cidrSubnetFgtPort2
  ipAddrFgtStart       = local.ipAddrFgtStart
  ipAddrFgtPort1List   = local.ipAddrFgtPort1ListByol
  ipAddrFgtPort2List   = local.ipAddrFgtPort2ListByol
  cntFgtByol           = var.cntFgtByol
  cntFgtPayg           = var.cntFgtPayg
  versionFgt           = var.versionFgt
  instanceTypeFgtFixed = var.instanceTypeFgtFixed
  portFgtHttps         = var.portFgtHttps
  asgFgtClusterPSK     = var.asgFgtClusterPSK
  instanceBootstrapFgt = "./modules/fortigate/fortigate.conf"
  licenseTypeFgt       = "byol"
  licenseFiles         = var.licenseFiles
  sgFgtPort1           = aws_security_group.sgFgtPort1.id
  sgFgtPort2           = aws_security_group.sgFgtPort2.id
  subnetFgtPort1       = [for subnet in aws_subnet.subnetFgtPort1 : subnet.id]
  subnetFgtPort2       = [for subnet in aws_subnet.subnetFgtPort2 : subnet.id]
  ipAddrEniGwlbAz1     = data.aws_network_interface.eniGwlbeVpcNgfw[0].private_ip
  ipAddrEniGwlbAz2     = length(var.azList) == 1 ? null : data.aws_network_interface.eniGwlbeVpcNgfw[1].private_ip
  ipAddrEniGwlbAz3     = length(var.azList) == 3 ? data.aws_network_interface.eniGwlbeVpcNgfw[2].private_ip : null
}
