locals {
  enableNewResrcGrp = var.paramNameResrcGrp == "" ? true : false
}

resource "azurerm_resource_group" "resrcGrp" {
  count = local.enableNewResrcGrp == true ? 1 : 0

  name     = var.nameResrcGrp
  location = var.locationResrcGrp

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}



locals {
  nameResrcGrp = local.enableNewResrcGrp == true ? azurerm_resource_group.resrcGrp[0].name : var.paramNameResrcGrp
}

locals {
  enableNewVnetNgfw = var.paramNameVnetNgfw != "" && var.paramNameResrcGrp != "" ? false : true
}

resource "azurerm_virtual_network" "vnetNgfw" {
  count = local.enableNewVnetNgfw == true ? 1 : 0

  name                = var.nameVnetNgfw
  location            = var.locationVnetNgfw
  resource_group_name = local.nameResrcGrp
  address_space       = [var.cidrVnetNgfw]

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}



data "azurerm_virtual_network" "vnetNgfw" {
  count = local.enableNewVnetNgfw == true ? 0 : 1

  name                = var.paramNameVnetNgfw
  resource_group_name = var.paramNameResrcGrp
}

locals {
  locationVnetNgfw = local.enableNewVnetNgfw == true ? var.locationVnetNgfw : data.azurerm_virtual_network.vnetNgfw[0].location
}
