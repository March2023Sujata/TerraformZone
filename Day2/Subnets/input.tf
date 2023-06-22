variable "vnet_info" {
  type = object({
    location          = string,
    vnet_addressSpace = list(string),
    subnets_names     = list(string),
    resource_group    = string,
    vnet              = string,
  })
  default = {
    location          = "eastus"
    vnet_addressSpace = ["192.168.0.0/16"]
    subnets_names     = ["App", "DB", "TEST", "FTP", "Mail", "Release"]
    resource_group    = "ntier_RG"
    vnet              = "ntire_Vnet"
  }
}