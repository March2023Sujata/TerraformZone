output "appserver_private_ip" {
  value = azurerm_linux_virtual_machine.main.private_ip_address
}
output "appserver_public_ip" {
  value = azurerm_linux_virtual_machine.main.public_ip_address
}
output "db_endpoint" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}