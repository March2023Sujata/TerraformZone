terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "azure_VM" {
  source = "git::https://github.com/Sujata-Joshi/terraformModuleTest.git//modules/azure_VM?ref=master"
  vnet_info = {
    location             = "eastus"
    vnet_addressSpace    = ["192.168.0.0/16"]
    subnets_names        = ["Web", "DB"]
    resource_group       = "ntier_RG"
    vnet                 = "ntire_Vnet"
    network_interface    = "ntire_nic"
    vm_name              = ["Red", "Green"]
    ip_configuration     = "testconfiguration1"
    address_allocation   = "Dynamic"
    vm_size              = "Standard_B1s"
    public_ip            = "vm_public_ip"
    admin_username       = "sujata"
    disk_name            = "myosdisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    security_group_name  = "ssh_nsg"
  }
}

resource "null_resource" "exec_red" {
  count = var.trigger_id == "red" ? 1 : 0
  triggers = {
    trigger_id = var.trigger_id
  }
  connection {
    type        = "ssh"
    host        = module.azure_VM.Red_publicIP
    user        = module.azure_VM.Red_userName
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "file" {
    source      = "scp.service"
    destination = "/home/sujata/scp.service"
  }
  provisioner "file" {
    source      = "scripts.sh"
    destination = "/home/sujata/scripts.sh"
  }
  provisioner "remote-exec" {
    script = "./scripts.sh"
  }
}
resource "null_resource" "exec_green" {
  count = var.trigger_id == "green" ? 1 : 0
  triggers = {
    trigger_id = var.trigger_id
  }
  connection {
    type        = "ssh"
    host        = module.azure_VM.Green_publicIP
    user        = module.azure_VM.Green_userName
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "file" {
    source      = "scp.service"
    destination = "/home/sujata/scp.service"
  }
  provisioner "file" {
    source      = "scripts.sh"
    destination = "/home/sujata/scripts.sh"
  }
  provisioner "remote-exec" {
    script = "./scripts.sh"
  }
}

output "RED" {
  value = "http://${module.azure_VM.Red_publicIP}:8080"
}
output "GREEN" {
  value = "http://${module.azure_VM.Green_publicIP}:8080"
}