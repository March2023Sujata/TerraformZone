
resource "azurerm_virtual_network" "ntireVnet" {
  name                = format("${terraform.workspace}-%s", var.vnet_info.vnet)
  location            = data.azurerm_resource_group.my_RG.location
  resource_group_name = data.azurerm_resource_group.my_RG.name
  address_space       = var.vnet_info.vnet_addressSpace
  tags = {
    Env       = "${terraform.workspace}"
    createdBy = "Terraform_ARM"
  }
}
resource "azurerm_subnet" "subnets" {
  count                = length(var.vnet_info.subnets_names)
  name                 = var.vnet_info.subnets_names[count.index]
  resource_group_name  = data.azurerm_resource_group.my_RG.name
  virtual_network_name = azurerm_virtual_network.ntireVnet.name
  address_prefixes     = [cidrsubnet(var.vnet_info.vnet_addressSpace[0], 8, count.index)]
  depends_on = [
    azurerm_virtual_network.ntireVnet
  ]
}