locals {
  nameRtbInspection = "rtb-inspection"
}

#################### Route Table DEFINITION ####################
resource "azurerm_route_table" "rtbFgtInspection" {
  depends_on          = [azurerm_lb.ilb]
  name                = local.nameRtbInspection
  resource_group_name = local.nameResrcGrp
  location            = local.locationVnetNgfw

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}


#################### Route Table Association DEFINITION ####################
# [EXAMPLE] 
# associate with your desired subnet, 
# traffic of the subnet will be redirect to FortiGate for inspection
#
# resource "azurerm_subnet_route_table_association" "associateSubnetWithRtbInspection" {
#   depends_on     = [azurerm_route_table.rtbFgtInspection]
#   subnet_id      = azurerm_subnet.subnetApp.id
#   route_table_id = azurerm_route_table.rtbFgtInspection.id
# }



#################### UDR(User Defined Routes) DEFINITION ####################
resource "azurerm_route" "internalRoute" {
  name                   = "default"
  resource_group_name    = local.nameResrcGrp
  route_table_name       = azurerm_route_table.rtbFgtInspection.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_lb.ilb.frontend_ip_configuration.0.private_ip_address
}

