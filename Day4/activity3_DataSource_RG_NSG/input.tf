variable "nsg_info" {
  type = object({
    nsg_name = string,
  })
  default = {
    nsg_name = "nsg1"
  }
}