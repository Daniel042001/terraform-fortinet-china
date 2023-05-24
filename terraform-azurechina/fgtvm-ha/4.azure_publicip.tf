locals {
  prefixEipFgtMgmt = "eip-mgmt-fgt"
}

resource "azurerm_public_ip" "eipFgtMgmt" {
  count               = 2
  name                = "${local.prefixEipFgtMgmt}${count.index + 1}"
  resource_group_name = local.nameResrcGrp
  location            = local.locationVnetNgfw
  allocation_method   = "Static"
  sku                 = "Standard"
  # https://docs.microsoft.com/en-us/azure/availability-zones/az-overview
  # zones = azurerm_virtual_network.vnetNgfw.location == "chinanorth3" ? [var.azPrimary] : []
}
