terraform {
  required_version = ">= 1.2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.11 , < 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  alias = "East_US"

}
provider "azurerm" {
  features {}
  alias = "WEST_US"

}