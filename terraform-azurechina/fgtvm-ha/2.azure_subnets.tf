locals {
  prefixSubnetFgtPort1 = "subnet-fgt-port1"
  prefixSubnetFgtPort2 = "subnet-fgt-port2"
  prefixSubnetFgtPort3 = "subnet-fgt-port3"
  prefixSubnetFgtPort4 = "subnet-fgt-port4"
}



locals {
  nameVnetNgfw = local.enableNewVnetNgfw == true ? azurerm_virtual_network.vnetNgfw[0].name : var.paramNameVnetNgfw
}



resource "azurerm_subnet" "subnetFgtPort1" {
  name                 = local.prefixSubnetFgtPort1
  resource_group_name  = local.nameResrcGrp
  virtual_network_name = local.nameVnetNgfw
  address_prefixes     = [var.cidrSubnetFgtPort1]
}

resource "azurerm_subnet" "subnetFgtPort2" {
  name                 = local.prefixSubnetFgtPort2
  resource_group_name  = local.nameResrcGrp
  virtual_network_name = local.nameVnetNgfw
  address_prefixes     = [var.cidrSubnetFgtPort2]
}

resource "azurerm_subnet" "subnetFgtPort3" {
  name                 = local.prefixSubnetFgtPort3
  resource_group_name  = local.nameResrcGrp
  virtual_network_name = local.nameVnetNgfw
  address_prefixes     = [var.cidrSubnetFgtPort3]
}

resource "azurerm_subnet" "subnetFgtPort4" {
  name                 = local.prefixSubnetFgtPort4
  resource_group_name  = local.nameResrcGrp
  virtual_network_name = local.nameVnetNgfw
  address_prefixes     = [var.cidrSubnetFgtPort4]
}
