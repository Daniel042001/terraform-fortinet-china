locals {
  nameElb    = "ELB"
  nameEipElb = "eip-elb"
}

resource "azurerm_public_ip" "eipElb" {
  name                = local.nameEipElb
  resource_group_name = local.nameResrcGrp
  location            = local.locationVnetNgfw
  allocation_method   = "Static"
  sku                 = "Standard"
  # https://docs.microsoft.com/en-us/azure/availability-zones/az-overview
  # zones = azurerm_virtual_network.vnetNgfw.location == "chinanorth3" ? [var.azPrimary, var.azSecondary] : []
}

resource "azurerm_lb" "elb" {
  name                = local.nameElb
  resource_group_name = local.nameResrcGrp
  location            = local.locationVnetNgfw
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = local.nameEipElb
    public_ip_address_id = azurerm_public_ip.eipElb.id
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "azurerm_lb_probe" "elbprobe" {
  loadbalancer_id = azurerm_lb.elb.id
  name            = "elbprobe"
  protocol        = "Tcp"
  port            = 8008
}



resource "azurerm_lb_backend_address_pool" "elbBackendAddrPool" {
  loadbalancer_id = azurerm_lb.elb.id
  name            = "FGT-HA-Cluster"
}

resource "azurerm_network_interface_backend_address_pool_association" "associateElbWithFgtPort1" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.eniFgtPort1[count.index].id
  ip_configuration_name   = "ip-${local.prefixEniFgtPort1}${count.index + 1}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.elbBackendAddrPool.id
}



resource "azurerm_lb_rule" "elbRuleVpnIke" {
  loadbalancer_id                = azurerm_lb.elb.id
  name                           = "LBRule-VPN-IKE"
  protocol                       = "Udp"
  frontend_port                  = 500
  backend_port                   = 500
  frontend_ip_configuration_name = local.nameEipElb
  disable_outbound_snat          = true
  probe_id                       = azurerm_lb_probe.elbprobe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elbBackendAddrPool.id]
}

resource "azurerm_lb_rule" "elbRuleVpnNatt" {
  loadbalancer_id                = azurerm_lb.elb.id
  name                           = "LBRule-VPN-NATT"
  protocol                       = "Udp"
  frontend_port                  = 4500
  backend_port                   = 4500
  frontend_ip_configuration_name = local.nameEipElb
  disable_outbound_snat          = true
  probe_id                       = azurerm_lb_probe.elbprobe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elbBackendAddrPool.id]
}



resource "azurerm_lb_outbound_rule" "elbSnatInternet" {
  name                    = "ToInternet"
  loadbalancer_id         = azurerm_lb.elb.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.elbBackendAddrPool.id

  frontend_ip_configuration {
    name = local.nameEipElb
  }
}
