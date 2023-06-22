variable "password_info" {
  type = object({
    pwd_length  = number,
    admin_login = string,
  })
  default = {
    pwd_length  = 8
    admin_login = "adminsujata"
  }
}
variable "resource_group_info" {
  type = object({
    resource_group = string,
    location       = string,
  })
  default = {
    resource_group = "data_RG"
    location       = "eastus"
  }
}
variable "database_info" {
  type = object({
    db_name  = string,
    version  = string,
    sql_name = string
  })
  default = {
    db_name  = "db-dev"
    version  = "12.0"
    sql_name = "sql-dev-emp"
  }
}

