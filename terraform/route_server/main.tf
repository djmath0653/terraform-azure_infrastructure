##################################################################################
# Route Server network 
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
  peers                = var.peers

  tags = var.tags
}

resource "azurerm_public_ip" "route_server_public_ip" {
  name                = var.route_server_public_ip_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  allocation_method = "Static"   # Options: Static or Dynamic
  sku               = "Standard" # Recommended for production workloads
  ip_version        = "IPv4"     # Options: IPv4 or IPv6
  tags              = var.tags
}

resource "azurerm_route_server" "route_server" {
  name                = var.route_server_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  subnet_id            = module.virtual_network.subnet.RouteServerSubnet.id
  sku                  = "Standard"
  public_ip_address_id = azurerm_public_ip.route_server_public_ip.id
  tags                 = var.tags
}

resource "azurerm_route_server_bgp_connection" "peer_1" {
  name            = var.route_server_peer_1_name
  route_server_id = azurerm_route_server.route_server.id
  peer_asn        = var.route_server_peer_1_asn
  peer_ip         = var.route_server_peer_1_ip
}

resource "azurerm_route_server_bgp_connection" "peer_2" {
  name            = var.route_server_peer_2_name
  route_server_id = azurerm_route_server.route_server.id
  peer_asn        = var.route_server_peer_2_asn
  peer_ip         = var.route_server_peer_2_ip
}