##################################################################################
# Connectivity network 
##################################################################################
module "resource_group" {
  source = "../../modules/arm_resource_group"

  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source = "../../modules/arm_virtual_network"

  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  virtual_network_name = var.vnet_name
  address_space        = var.address_space
  subnets              = var.subnets
  route_tables         = var.route_tables
  peers                = var.peers
  tags                 = var.tags
  diagnostic_settings = {
    diag = {
      workspace_resource_id = local.workspace_resource_id
    }
  }
}


resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  name                        = "AllowAnyIn"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = module.resource_group.name
  network_security_group_name = module.virtual_network.subnet_nsg_names.palo-trust-Subnet-01
}

resource "azurerm_network_security_rule" "allow_vnet_outbound" {
  name                        = "AllowAnyOut"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = module.resource_group.name
  network_security_group_name = module.virtual_network.subnet_nsg_names.palo-trust-Subnet-01
}

