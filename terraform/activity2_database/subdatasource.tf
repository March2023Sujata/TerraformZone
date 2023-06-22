data "azurerm_subnet" "my_sub" {
  name                 = var.vnet_info.subnets_names[0]
  virtual_network_name = var.vnet_info.vnet
  resource_group_name  = var.vnet_info.resource_group
}