resource "azurerm_network_security_group" "NSG1" {
  name                = var.nsg_info.nsg_name
  resource_group_name = data.azurerm_resource_group.my_RG.name
  location            = data.azurerm_resource_group.my_RG.location
  tags                = data.azurerm_resource_group.my_RG.tags

  security_rule {
    name                       = "test123"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}