vnet_info = {
  location             = "eastus"
  vnet_addressSpace    = ["192.168.0.0/16"]
  subnets_names        = ["App", "DB"]
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
}