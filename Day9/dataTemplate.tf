
data "template_file" "dataAboutVM" {
  template = <<EOF
  ${azurerm_linux_virtual_machine.main.public_ip_address} ansible_user=sujata
  EOF
}