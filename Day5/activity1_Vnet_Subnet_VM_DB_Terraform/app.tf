resource "azurerm_public_ip" "public_ip" {
  name                = var.vnet_info.public_ip
  resource_group_name = azurerm_resource_group.ntierRG.name
  location            = azurerm_resource_group.ntierRG.location
  allocation_method   = var.vnet_info.address_allocation
  depends_on = [
    azurerm_subnet.subnets
  ]
}

resource "azurerm_network_interface" "ntireNIC" {
  name                = var.vnet_info.network_interface
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name

  ip_configuration {
    name                          = var.vnet_info.ip_configuration
    subnet_id                     = azurerm_subnet.subnets[0].id
    private_ip_address_allocation = var.vnet_info.address_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  depends_on = [
    azurerm_subnet.subnets,
    azurerm_public_ip.public_ip
  ]
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.vnet_info.security_group_name
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.ntireNIC.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_network_interface.ntireNIC,
    azurerm_network_security_group.nsg
  ]
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.vnet_info.vm_name
  location                        = azurerm_resource_group.ntierRG.location
  resource_group_name             = azurerm_resource_group.ntierRG.name
  network_interface_ids           = [azurerm_network_interface.ntireNIC.id]
  size                            = var.vnet_info.vm_size
  admin_username                  = var.vnet_info.admin_username
  admin_password                  = var.vnet_info.admin_password
  disable_password_authentication = false


  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  os_disk {
    name                 = var.vnet_info.disk_name
    caching              = var.vnet_info.caching
    storage_account_type = var.vnet_info.storage_account_type
  }
  depends_on = [
    azurerm_network_interface.ntireNIC
  ]
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
}