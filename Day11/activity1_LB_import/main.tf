resource "azurerm_resource_group" "myRG" {

  location = "eastus"
  name     = "importINTerraform"
  tags = {
    "Env" = "Dev"
  }
}