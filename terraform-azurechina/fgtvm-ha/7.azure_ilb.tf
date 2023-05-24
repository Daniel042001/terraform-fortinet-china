locals {
  ilbName   = "ILB"
  ipIlbName = "ip-ilb"
}

resource "azurerm_lb" "ilb" {
  name                = local.ilbName
  resource_group_name = local.nameResrcGrp
  location            = local.locationVnetNgfw
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = local.ipIlbName
    subnet_id                     = azurerm_subnet.subnetFgtPort2.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "azurerm_lb_probe" "ilbprobe" {
  loadbalancer_id = azurerm_lb.ilb.id
  name            = "ilbprobe"
  protocol        = "Tcp"
  port            = 8008
}

resource "azurerm_lb_rule" "ilbRulePassthrough" {
  loadbalancer_id                = azurerm_lb.ilb.id
  name                           = "LBRule-passthrough"
  frontend_ip_configuration_name = local.ipIlbName
  probe_id                       = azurerm_lb_probe.ilbprobe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ilbBackendAddrPool.id]
  # a.k.a. 'HA Port'
  protocol      = "All"
  frontend_port = 0
  backend_port  = 0
}

resource "azurerm_lb_backend_address_pool" "ilbBackendAddrPool" {
  loadbalancer_id = azurerm_lb.ilb.id
  name            = "FGT-HA-Cluster"
}

resource "azurerm_network_interface_backend_address_pool_association" "associateIlbWithFgtPort2" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.eniFgtPort2[count.index].id
  ip_configuration_name   = "ip-${local.prefixEniFgtPort2}${count.index + 1}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilbBackendAddrPool.id
}

