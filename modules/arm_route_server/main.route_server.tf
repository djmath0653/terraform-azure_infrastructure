##################################################################################
# Route Server network 
##################################################################################
resource "azurerm_route_server" "route_server" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id                        = var.subnet_id
  sku                              = "Standard"
  public_ip_address_id             = var.public_ip_address_id
  branch_to_branch_traffic_enabled = true
  tags                             = var.tags
}

resource "azurerm_route_server_bgp_connection" "peer_1" {
  name            = var.peer_1_name
  route_server_id = azurerm_route_server.route_server.id
  peer_asn        = var.peer_1_asn
  peer_ip         = var.peer_1_ip
}

resource "azurerm_route_server_bgp_connection" "peer_2" {
  depends_on      = [azurerm_route_server_bgp_connection.peer_1]
  name            = var.peer_2_name
  route_server_id = azurerm_route_server.route_server.id
  peer_asn        = var.peer_2_asn
  peer_ip         = var.peer_2_ip
}

