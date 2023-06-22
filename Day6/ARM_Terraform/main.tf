resource "azurerm_resource_group" "ntierRG" {
  name     = var.vnet_info.resource_group
  location = var.vnet_info.location
}

resource "azurerm_resource_group_template_deployment" "armTemp" {
  name                = "arm-deploy"
  resource_group_name = azurerm_resource_group.ntierRG.name
  deployment_mode     = "Incremental"
  template_content    = file("armtoterraform.json")
}

