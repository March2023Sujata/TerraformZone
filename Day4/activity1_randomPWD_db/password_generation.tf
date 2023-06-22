resource "random_password" "password" {
  length  = var.password_info.pwd_length
  special = true
}
