
# Load Balancer ID
#output "web_lb_id" {
#description = "Web Load Balancer ID."
#value       = azurerm_lb.loadbalancer
#}

# Load Balancer Frontend IP Configuration Block
#output "web_lb_frontend_ip_configuration" {
# description = "Web LB frontend_ip_configuration Block"
# value       = [azurerm_lb.loadbalancer.frontend_ip_configuration]
#}

#LB Public IP
output "lb_public_ip_address" {
  description = "Web Load Balancer Public Address"
  value       = "http://${azurerm_public_ip.LB_publicIP.ip_address}"
}

# WEB Public IP
output "apache_WEB1" {
  value = "http://${azurerm_linux_virtual_machine.main[0].public_ip_address}"
}
# DB Public IP
output "apache_WEB2" {
  value = "http://${azurerm_linux_virtual_machine.main[1].public_ip_address}"
}