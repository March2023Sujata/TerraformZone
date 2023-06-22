
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.vnet_info.sql_name
  resource_group_name          = azurerm_resource_group.ntierRG.name
  location                     = azurerm_resource_group.ntierRG.location
  version                      = var.vnet_info.version
  administrator_login          = var.vnet_info.dbadmin_login
  administrator_login_password = var.vnet_info.dbpassword
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}

resource "azurerm_mssql_database" "sql_db" {
  name      = var.vnet_info.db_name
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = var.vnet_info.sku_name
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
  depends_on = [
    azurerm_mssql_server.sql_server
  ]
}