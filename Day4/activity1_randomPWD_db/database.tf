resource "azurerm_resource_group" "dataRG" {
  name     = var.resource_group_info.resource_group
  location = var.resource_group_info.location
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = var.database_info.sql_name
  resource_group_name          = azurerm_resource_group.dataRG.name
  location                     = azurerm_resource_group.dataRG.location
  version                      = var.database_info.version
  administrator_login          = var.password_info.admin_login
  administrator_login_password = random_password.password.result
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
  depends_on = [
    azurerm_resource_group.dataRG
  ]
}

resource "azurerm_mssql_database" "sql_db" {
  name      = var.database_info.db_name
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic"
  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
  depends_on = [
    azurerm_mssql_server.sql_server
  ]
}