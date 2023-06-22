# Red Public IP
output "Red_publicIP" {
  value = azurerm_linux_virtual_machine.main[0].public_ip_address
}

# Green Public IP
output "Green_publicIP" {
  value = azurerm_linux_virtual_machine.main[1].public_ip_address
}

# Red user name
output "Red_userName" {
  value = azurerm_linux_virtual_machine.main[0].admin_username
}

# Green user name
output "Green_userName" {
  value = azurerm_linux_virtual_machine.main[1].admin_username
}