output "A_General-Information" {
  value = [
    "RESOURCE-GROUP-NAME: ${local.nameResrcGrp}",
    "VNET-NAME: ${local.nameVnetNgfw}",
    "VNET-LOCATION: ${local.locationVnetNgfw}",
    "VNET-CIDR: ${var.cidrVnetNgfw}"
  ]
}

output "B_FortiGate-BYOL-Statistics" {
  sensitive = true
  value = [
    for fgt in azurerm_linux_virtual_machine.fgt :
    "${fgt.name}: https://${azurerm_public_ip.eipFgtMgmt[index(azurerm_linux_virtual_machine.fgt, fgt)].ip_address}:${var.portFgtHttps} | USER_NAME:${var.adminUsername}/PWD:${var.adminPassword}"
  ]
}

output "C_RedirectTraffic-To-ILB" {
  value = [
    "VirtualAppliance: ${azurerm_lb.ilb.frontend_ip_configuration.0.private_ip_address}"
  ]
}

output "D_IPsec-Azure-GW" {
  value = [
    "AZURE-ELB: ${azurerm_public_ip.eipElb.ip_address}"
  ]
}
