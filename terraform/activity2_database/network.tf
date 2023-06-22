resource "azurerm_resource_group" "ntierRG" {
  name     = var.vnet_info.resource_group
  location = var.vnet_info.location
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
}

resource "azurerm_virtual_network" "ntireVnet" {
  name                = var.vnet_info.vnet
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name
  address_space       = var.vnet_info.vnet_addressSpace
  depends_on = [
    azurerm_resource_group.ntierRG
  ]
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.vnet_info.subnets_names)
  name                 = var.vnet_info.subnets_names[count.index]
  resource_group_name  = azurerm_resource_group.ntierRG.name
  virtual_network_name = azurerm_virtual_network.ntireVnet.name
  address_prefixes     = [cidrsubnet(var.vnet_info.vnet_addressSpace[0], 8, count.index)]
  depends_on = [
    azurerm_virtual_network.ntireVnet
  ]
}




