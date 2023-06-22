resource "azurerm_public_ip" "LB_publicIP" {
  name                = "PublicIPForLB"
  resource_group_name = azurerm_resource_group.ntierRG.name
  location            = azurerm_resource_group.ntierRG.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
}

resource "azurerm_lb" "loadbalancer" {
  name                = "TestLoadBalancer"
  resource_group_name = azurerm_resource_group.ntierRG.name
  location            = azurerm_resource_group.ntierRG.location
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    public_ip_address_id = azurerm_public_ip.LB_publicIP.id
    name                 = "PublicIPAddress"
  }

  depends_on = [
    azurerm_public_ip.LB_publicIP
  ]
}

resource "azurerm_lb_backend_address_pool" "backendfPool" {
  name            = "web-backend"
  loadbalancer_id = azurerm_lb.loadbalancer.id
  depends_on = [
    azurerm_lb.loadbalancer
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "LB_Back_Asso" {
  count                   = length(var.vnet_info.subnets_names)
  network_interface_id    = azurerm_network_interface.ntireNIC.*.id[count.index]
  ip_configuration_name   = azurerm_network_interface.ntireNIC.*.ip_configuration.0.name[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendfPool.id
  depends_on = [
    azurerm_network_interface.ntireNIC,
    azurerm_lb_backend_address_pool.backendfPool
  ]
}
resource "azurerm_lb_probe" "lb_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 22
  loadbalancer_id = azurerm_lb.loadbalancer.id
  depends_on = [
    azurerm_lb.loadbalancer
  ]
}
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "SSH-LB-rule"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  probe_id                       = azurerm_lb_probe.lb_probe.id
  backend_address_pool_ids       = ["${azurerm_lb_backend_address_pool.backendfPool.id}"]
  depends_on = [
    azurerm_lb.loadbalancer,
    azurerm_lb_probe.lb_probe,
    azurerm_lb_backend_address_pool.backendfPool
  ]
}


resource "azurerm_lb_nat_rule" "WEB_natRule" {
  count                          = length(var.vnet_info.subnets_names)
  resource_group_name            = azurerm_resource_group.ntierRG.name
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "WEB_natRule-${count.index + 1}"
  protocol                       = "Tcp"
  frontend_port                  = var.vnet_info.ports[count.index]
  backend_port                   = var.vnet_info.ports[count.index]
  frontend_ip_configuration_name = "PublicIPAddress"
  depends_on = [
    azurerm_resource_group.ntierRG,
    azurerm_lb.loadbalancer
  ]
}

resource "azurerm_network_interface_nat_rule_association" "natRuleAsso" {
  count                 = length(var.vnet_info.subnets_names)
  network_interface_id  = azurerm_network_interface.ntireNIC[count.index].id
  ip_configuration_name = azurerm_network_interface.ntireNIC[count.index].ip_configuration[0].name
  nat_rule_id           = azurerm_lb_nat_rule.WEB_natRule[count.index].id
  depends_on = [
    azurerm_network_interface.ntireNIC,
    azurerm_lb_nat_rule.WEB_natRule
  ]
}


