locals {
  # ipAddrFwbStart is the first ip assigned to FortiWeb port1 in the subnet of the first AZ.
  ipAddrFwbStart = 11
}

locals {
  ipAddrFwbPort1ListByol = [
    for cnt in range(var.cntFwbByol) :
    cidrhost(var.cidrSubnetFwbPort1[cnt % length(var.azList)], (local.ipAddrFwbStart + cnt))
  ]
}

module "fortiweb-byol" {
  source               = "./modules/fortiweb"
  ProjectName          = var.ProjectName
  CompanyName          = var.CompanyName
  enableDemoBastion    = var.enableDemoBastion
  regionName           = var.regionName
  azList               = var.azList
  cidrSubnetFwbPort1   = var.cidrSubnetFwbPort1
  ipAddrFwbStart       = local.ipAddrFwbStart
  ipAddrFwbPort1List   = local.ipAddrFwbPort1ListByol
  cntFwbByol           = var.cntFwbByol
  instanceTypeFwbFixed = var.instanceTypeFwbFixed
  portFwbHttps         = var.portFwbHttps
  licenseTypeFwb       = "byol"
  sgFwbPort1           = var.enableFgStandalone == true ? null : aws_security_group.sgFwbPort1[0].id
  subnetFwbPort1       = [for subnet in aws_subnet.subnetFwbPort1 : subnet.id]
}
