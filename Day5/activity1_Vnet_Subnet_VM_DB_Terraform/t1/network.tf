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
  for_each             = var.subnets
  name                 = each.value
  resource_group_name  = azurerm_resource_group.ntierRG.name
  virtual_network_name = azurerm_virtual_network.ntireVnet.name
  address_prefixes={for k in var.subnets:  cidrsubnet(var.vnet_info.vnet_addressSpace[0], 8, each.value)
  #address_prefixes = [cidrsubnet(var.vnet_info.vnet_addressSpace[0], 8, each.value)]
  depends_on = [
    azurerm_virtual_network.ntireVnet
  ]
}




