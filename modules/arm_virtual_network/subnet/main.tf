resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.cidrs

  private_endpoint_network_policies             = var.private_endpoint_network_policies
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled


  service_endpoints = var.service_endpoints

  dynamic "delegation" {
    for_each = var.delegations
    content {
      name = delegation.key
      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}



resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count = (azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group ? 1 : 0)

  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.0.id
}

resource "azurerm_network_security_group" "nsg" {
  count = (azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group ? 1 : 0)

  name                = local.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  count = ((azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group && var.configure_nsg_rules) ? 1 : 0)

  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "deny_all_outbound" {
  count = ((azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group && var.configure_nsg_rules) ? 1 : 0)

  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_lb_inbound" {
  count = ((azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group && var.configure_nsg_rules && var.allow_lb_inbound) ? 1 : 0)

  name                        = "AllowAzureLoadBalancerIn"
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_internet_outbound" {
  count = ((azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group && var.configure_nsg_rules && var.allow_internet_outbound) ? 1 : 0)

  name                        = "AllowInternetOut"
  priority                    = 4093
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  count = ((azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group && var.configure_nsg_rules && var.allow_vnet_inbound) ? 1 : 0)

  name                        = "AllowVnetIn"
  priority                    = 4094
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_vnet_outbound" {
  count = ((azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group && var.configure_nsg_rules && var.allow_vnet_outbound) ? 1 : 0)

  name                        = "AllowVnetOut"
  priority                    = 4094
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_any_inbound" {
  count = ((azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group && var.configure_nsg_rules && var.allow_any_inbound) ? 1 : 0)

  name                        = "AllowAnyOut"
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_any_outbound" {
  count = ((azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group && var.configure_nsg_rules && var.allow_any_outbound) ? 1 : 0)

  name                        = "AllowAnyOut"
  priority                    = 4093
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
  }