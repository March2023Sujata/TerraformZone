
variable "vnet_info" {
  type = object({
    location          = string,
    vnet_addressSpace = list(string),
    subnets_names     = list(string)
  })
  default = {
    location          = "eastus"
    vnet_addressSpace = ["192.168.0.0/16"]
    subnets_names     = ["App", "DB", "TEST", "FTP", "Mail", "Release"]
  }
}

