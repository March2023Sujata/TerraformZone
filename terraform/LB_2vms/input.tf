variable "vnet_info" {
  type = object({
    location             = string,
    vnet_addressSpace    = list(string),
    subnets_names        = list(string),
    resource_group       = string,
    vnet                 = string,
    network_interface    = string,
    vm_name              = string,
    ip_configuration     = string,
    address_allocation   = string,
    vm_size              = string,
    public_ip            = string,
    admin_username       = string,
    admin_password       = string,
    disk_name            = string,
    caching              = string,
    storage_account_type = string,
    LB_type              = string,
    ports                = list(number)
  })
  default = {
    location             = "eastus"
    vnet_addressSpace    = ["192.168.0.0/16"]
    subnets_names        = ["Web", "DB"]
    resource_group       = "ntier_RG"
    vnet                 = "ntire_Vnet"
    network_interface    = "ntire_nic"
    vm_name              = "ntireVM"
    ip_configuration     = "testconfiguration1"
    address_allocation   = "Dynamic"
    vm_size              = "Standard_B1s"
    public_ip            = "vm_public_ip"
    admin_username       = "sujata"
    admin_password       = "Password@1234"
    disk_name            = "myosdisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    LB_type              = "Public"
    ports                = [80, 443]
  }
}
variable "trigger_id" {
  type    = string
  default = "0.0.0.0"
}