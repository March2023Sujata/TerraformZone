resource "azuread_user" "user" {
  display_name        = var.user_info.name
  department          = var.user_info.dept
  user_principal_name = var.user_info.mail
  password            = var.user_info.pwd
}
