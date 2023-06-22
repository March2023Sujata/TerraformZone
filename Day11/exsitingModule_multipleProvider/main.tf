resource "azurerm_resource_group" "ntierRG_EASTUS" {
  provider = azurerm.East_US
  location = var.resource_group_location_EASTUS
  name     = var.resource_group_name_EASTUS
  tags = {
    "Env" = "Dev"
  }
}

module "vnet_EASTUS" {
  providers = {
    azurerm=azurerm.East_US
   }
  source   = "Azure/vnet/azurerm"
  version  = "4.0.0"
  # insert the 3 required variables here
  resource_group_name = azurerm_resource_group.ntierRG_EASTUS.name
  vnet_location       = azurerm_resource_group.ntierRG_EASTUS.location
  use_for_each        = true
}

resource "azurerm_resource_group" "ntierRG_WESTUS" {
  provider = azurerm.WEST_US
  location = var.resource_group_location_WESTUS
  name     = var.resource_group_name_WESTUS
  tags = {
    "Env" = "Dev"
  }
}
module "vnet_WESTUS" {
  providers = {
    azurerm=azurerm.WEST_US
   }
  source   = "Azure/vnet/azurerm"
  version  = "4.0.0"
  # insert the 3 required variables here
  resource_group_name = azurerm_resource_group.ntierRG_WESTUS.name
  vnet_location       = azurerm_resource_group.ntierRG_WESTUS.location
  use_for_each        = true
}
