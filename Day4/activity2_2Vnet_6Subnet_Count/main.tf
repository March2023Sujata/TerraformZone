resource "azurerm_resource_group" "ntierRG" {
  name     = var.vnet_info.resource_group
  location = var.vnet_info.location
}

resource "azurerm_virtual_network" "ntireVnet" {
  count               = length(var.vnet_info.vnet)
  name                = var.vnet_info.vnet[count.index]
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name
  address_space       = [var.vnet_info.vnet_addressSpace[count.index]]
  depends_on = [
    azurerm_resource_group.ntierRG
  ]
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.vnet_info.subnets_names)
  name                 = var.vnet_info.subnets_names[count.index]
  resource_group_name  = azurerm_resource_group.ntierRG.name
  virtual_network_name = azurerm_virtual_network.ntireVnet[floor(count.index / 6)].name
  address_prefixes     = [cidrsubnet(var.vnet_info.vnet_addressSpace[floor(count.index / 6)], 8, count.index % 6)]
  depends_on = [
    azurerm_virtual_network.ntireVnet
  ]
}

