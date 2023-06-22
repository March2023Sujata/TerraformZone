variable "vnet_info" {
  type = object({
    location       = string,
    resource_group = string,
  })
  default = {
    location       = "eastus"
    resource_group = "NTIRE_RG"
  }
}