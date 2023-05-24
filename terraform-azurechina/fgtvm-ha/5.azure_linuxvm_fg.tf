locals {
  prefixEniFgtPort1 = "port1-fgt"
  prefixEniFgtPort2 = "port2-fgt"
  prefixEniFgtPort3 = "port3-fgt"
  prefixEniFgtPort4 = "port4-fgt"
}



################### FORTIGATE ENIs ####################
resource "azurerm_network_interface" "eniFgtPort1" {
  count               = 2
  name                = "eni-${local.prefixEniFgtPort1}${count.index + 1}"
  location            = local.locationVnetNgfw
  resource_group_name = local.nameResrcGrp

  enable_ip_forwarding = false

  ip_configuration {
    name                          = "ip-${local.prefixEniFgtPort1}${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnetFgtPort1.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "azurerm_network_interface" "eniFgtPort2" {
  count               = 2
  name                = "eni-${local.prefixEniFgtPort2}${count.index + 1}"
  location            = local.locationVnetNgfw
  resource_group_name = local.nameResrcGrp

  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ip-${local.prefixEniFgtPort2}${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnetFgtPort2.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "azurerm_network_interface" "eniFgtPort3" {
  count               = 2
  name                = "eni-${local.prefixEniFgtPort3}${count.index + 1}"
  location            = local.locationVnetNgfw
  resource_group_name = local.nameResrcGrp

  enable_ip_forwarding = false

  ip_configuration {
    name                          = "ip-${local.prefixEniFgtPort3}${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnetFgtPort3.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.consolidateHaPort == true ? azurerm_public_ip.eipFgtMgmt[count.index].id : null
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "azurerm_network_interface" "eniFgtPort4" {
  count               = 2
  name                = "eni-${local.prefixEniFgtPort4}${count.index + 1}"
  location            = local.locationVnetNgfw
  resource_group_name = local.nameResrcGrp

  enable_ip_forwarding = false

  ip_configuration {
    name                          = "ip-${local.prefixEniFgtPort4}${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnetFgtPort4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.consolidateHaPort == false ? azurerm_public_ip.eipFgtMgmt[count.index].id : null
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "azurerm_network_interface_security_group_association" "associateFgtWithNsgMgmt" {
  count                     = 2
  network_interface_id      = var.consolidateHaPort == true ? azurerm_network_interface.eniFgtPort3[count.index].id : azurerm_network_interface.eniFgtPort4[count.index].id
  network_security_group_id = azurerm_network_security_group.nsgFgtMgmt.id
}

data "azurerm_network_interface" "eniFgtPort3" {
  count = 2

  depends_on = [
    azurerm_network_interface.eniFgtPort3
  ]

  name                = "eni-${local.prefixEniFgtPort3}${count.index + 1}"
  resource_group_name = local.nameResrcGrp
}

data "azurerm_network_interface" "eniFgtPort4" {
  count = 2

  depends_on = [
    azurerm_network_interface.eniFgtPort4
  ]

  name                = "eni-${local.prefixEniFgtPort4}${count.index + 1}"
  resource_group_name = local.nameResrcGrp
}



################### FORTIGATE DATA-DISKs ####################
resource "azurerm_managed_disk" "dataDiskFgt" {
  count                = 2
  name                 = "FG-${var.CompanyName}-${count.index + 1}-DataDisk"
  resource_group_name  = local.nameResrcGrp
  location             = local.locationVnetNgfw
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachDataDiskToFgt" {
  count              = 2
  managed_disk_id    = azurerm_managed_disk.dataDiskFgt[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.fgt[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}



################### FORTIGATEs ####################
resource "azurerm_linux_virtual_machine" "fgt" {
  count               = 2
  name                = "FG-${var.CompanyName}-${count.index + 1}"
  resource_group_name = local.nameResrcGrp
  location            = local.locationVnetNgfw
  size                = var.instanceTypeFgtFixed

  disable_password_authentication = false
  admin_username                  = var.adminUsername
  admin_password                  = var.adminPassword

  custom_data = base64encode(templatefile("fortigate.conf",
    {
      licenseFile       = var.licenseFiles[count.index]
      licenseType       = "byol"
      adminsPort        = var.portFgtHttps
      enablePrimary     = count.index == 0 ? true : false
      cidrDestination   = var.cidrVnetNgfw
      consolidateHaPort = var.consolidateHaPort
      ipAddrHAsyncPeer  = data.azurerm_network_interface.eniFgtPort3[(count.index + 1) % 2].ip_configuration.0.private_ip_address
      ipAddrPort3       = data.azurerm_network_interface.eniFgtPort3[count.index].ip_configuration.0.private_ip_address
      ipAddrPort4       = data.azurerm_network_interface.eniFgtPort4[count.index].ip_configuration.0.private_ip_address
      ipMaskPort3       = cidrnetmask(var.cidrSubnetFgtPort3)
      ipMaskPort4       = cidrnetmask(var.cidrSubnetFgtPort4)
      ipAddrPort1Gw     = cidrhost(var.cidrSubnetFgtPort1, 1)
      ipAddrPort2Gw     = cidrhost(var.cidrSubnetFgtPort2, 1)
      ipAddrPort3Gw     = cidrhost(var.cidrSubnetFgtPort3, 1)
      ipAddrPort4Gw     = cidrhost(var.cidrSubnetFgtPort4, 1)
      hostname          = "FG-${var.CompanyName}-${count.index + 1}"
    }
  ))

  network_interface_ids = [
    azurerm_network_interface.eniFgtPort1[count.index].id,
    azurerm_network_interface.eniFgtPort2[count.index].id,
    azurerm_network_interface.eniFgtPort3[count.index].id,
    azurerm_network_interface.eniFgtPort4[count.index].id
  ]

  os_disk {
    name                 = "FG-${var.CompanyName}-${count.index + 1}-OSDisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "fortinet-cn"
    offer     = var.imageOfferFgtChina[var.imageVersion]
    sku       = var.skuFgtChina[var.imageVersion]
    version   = var.verFgtChina[var.imageVersion]
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}




