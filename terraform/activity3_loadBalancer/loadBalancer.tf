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
  name               = "web-backend"
  loadbalancer_id    = azurerm_lb.loadbalancer.id
  virtual_network_id = azurerm_virtual_network.ntireVnet.id
  depends_on = [
    azurerm_lb.loadbalancer,
    azurerm_virtual_network.ntireVnet
  ]
}

resource "azurerm_lb_nat_rule" "lb_natRule" {
  resource_group_name            = azurerm_resource_group.ntierRG.name
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "lb_natRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  depends_on = [
    azurerm_resource_group.ntierRG,
    azurerm_lb.loadbalancer
  ]
}

resource "azurerm_network_interface_nat_rule_association" "natRuleAsso" {
  network_interface_id  = azurerm_network_interface.ntireNIC.id
  ip_configuration_name = "testconfiguration1"
  nat_rule_id           = azurerm_lb_nat_rule.lb_natRule.id
  depends_on = [
    azurerm_network_interface.ntireNIC,
    azurerm_lb_nat_rule.lb_natRule
  ]

}
resource "azurerm_lb_probe" "lb_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.loadbalancer.id
  depends_on = [
    azurerm_lb.loadbalancer
  ]
}
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "LB-rule"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  probe_id                       = azurerm_lb_probe.lb_probe.id
  depends_on = [
    azurerm_lb.loadbalancer,
    azurerm_lb_probe.lb_probe
  ]

}


