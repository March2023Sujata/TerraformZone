resource "azurerm_resource_group" "ntierRG" {
  name     = var.vnet_info.resource_group
  location = var.vnet_info.location
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
}

resource "azurerm_virtual_network" "ntireVnet" {
  name                = var.vnet_info.vnet
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name
  address_space       = var.vnet_info.vnet_addressSpace
  depends_on = [
    azurerm_resource_group.ntierRG
  ]
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.vnet_info.subnets_names)
  name                 = var.vnet_info.subnets_names[count.index]
  resource_group_name  = azurerm_resource_group.ntierRG.name
  virtual_network_name = azurerm_virtual_network.ntireVnet.name
  address_prefixes     = [cidrsubnet(var.vnet_info.vnet_addressSpace[0], 8, count.index)]
  depends_on = [
    azurerm_virtual_network.ntireVnet
  ]
}
resource "azurerm_public_ip" "public_ip" {
  count               = length(var.vnet_info.subnets_names)
  name                = "WEB_Publibip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.ntierRG.name
  location            = azurerm_resource_group.ntierRG.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
}

resource "azurerm_network_interface" "ntireNIC" {
  count               = length(var.vnet_info.subnets_names)
  name                = "WEB_ntireNic-${count.index + 1}"
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name

  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnets[0].id
    private_ip_address_allocation = var.vnet_info.address_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "ssh_nsg"
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}
resource "azurerm_network_interface_security_group_association" "association" {
  count                     = length(var.vnet_info.subnets_names)
  network_interface_id      = azurerm_network_interface.ntireNIC[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_network_interface.ntireNIC,
    azurerm_network_security_group.nsg
  ]
}

resource "azurerm_subnet_network_security_group_association" "subnet_association" {
  count                     = length(var.vnet_info.subnets_names)
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


resource "azurerm_linux_virtual_machine" "main" {
  count                           = length(var.vnet_info.subnets_names)
  name                            = "WEB-ntireVM-${count.index + 1}"
  location                        = azurerm_resource_group.ntierRG.location
  resource_group_name             = azurerm_resource_group.ntierRG.name
  network_interface_ids           = [element(azurerm_network_interface.ntireNIC.*.id, count.index)]
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
    name                 = "WEB_OSdisk-${count.index + 1}"
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




resource "null_resource" "exec" {
  count = length(var.vnet_info.subnets_names)
  triggers = {
    trigger_id = var.trigger_id
  }
  connection {
    type     = "ssh"
    user     = azurerm_linux_virtual_machine.main[count.index].admin_username
    password = azurerm_linux_virtual_machine.main[count.index].admin_password
    host     = azurerm_linux_virtual_machine.main[count.index].public_ip_address
  }
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install apache2 -y"]
  }
}
