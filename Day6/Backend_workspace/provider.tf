terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.48.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "backendStorage"
    storage_account_name = "storagbackend"
    container_name       = "storagecontainer"
    key                  = "dev-terraform-tfstate"
  }
}

provider "azurerm" {
  features {}
}