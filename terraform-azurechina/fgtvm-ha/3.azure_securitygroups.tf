locals {
  sgFgtPort4 = {
    icmp = {
      priority               = 100
      name                   = "ICMP"
      ip_protocol            = "Icmp"
      destination_port_range = "*"
    },
    ssh = {
      priority               = 110
      name                   = "SSH"
      ip_protocol            = "Tcp"
      destination_port_range = "22"
    },
    fgthttps = {
      priority               = 120
      name                   = "FGTHTTPS"
      ip_protocol            = "Tcp"
      destination_port_range = "${var.portFgtHttps}"
    }
  }
}



resource "azurerm_network_security_group" "nsgFgtMgmt" {
  name                = "nsg-fgt-mgmt"
  location            = local.locationVnetNgfw
  resource_group_name = local.nameResrcGrp

  dynamic "security_rule" {
    for_each = local.sgFgtPort4
    content {
      name                       = lookup(security_rule.value, "name", null)
      priority                   = lookup(security_rule.value, "priority", null)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = lookup(security_rule.value, "ip_protocol", null)
      source_port_range          = "*"
      destination_port_range     = lookup(security_rule.value, "destination_port_range", null)
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}




