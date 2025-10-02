##################################################################################
# Route Server network 
##################################################################################
# This is the module call
module "public_ip_address" {
  source = "../../modules/arm_public_ip_address"

  name                = var.route_server_public_ip_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  allocation_method = "Static"   # Options: Static or Dynamic
  sku               = "Standard" # Recommended for production workloads
  ip_version        = "IPv4"     # Options: IPv4 or IPv6
  tags              = var.tags
}


module "route_server" {
  source = "../../modules/arm_route_server"

  name                             = var.route_server_name
  resource_group_name              = module.resource_group.name
  location                         = module.resource_group.location
  subnet_id                        = module.virtual_network.subnet.RouteServerSubnet.id
  public_ip_address_id             = module.public_ip_address.id
  branch_to_branch_traffic_enabled = true
  tags                             = var.tags


  peer_1_name = var.route_server_peer_1_name
  peer_1_asn  = var.route_server_peer_1_asn
  peer_1_ip   = var.route_server_peer_1_ip

  peer_2_name = var.route_server_peer_2_name
  peer_2_asn  = var.route_server_peer_2_asn
  peer_2_ip   = var.route_server_peer_2_ip
}

