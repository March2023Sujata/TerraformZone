variable "vnet_info" {
  type = object({
    location          = string,
    vnet_addressSpace = list(string),
    subnets_names     = list(string),
    resource_group    = string,
    vnet              = list(string),
  })
  default = {
    location          = "eastus"
    vnet_addressSpace = ["192.168.0.0/16", "10.0.0.0/16"]
    subnets_names     = ["App", "DB", "TEST", "FTP", "Mail", "Release", "App", "DB", "TEST", "FTP", "Mail", "Release"]
    resource_group    = "ntier_RG"
    vnet              = ["ntire_Vnet1", "ntire_Vnet2"]
  }
}