######################################################################################
# Global variables
######################################################################################
log_workspace_sub_id = "1cbd70a5-1547-4183-846f-12003f04578c"
location             = "eastus"
log_workspace_rg     = "hub-p-logs-rg01"
log_workspace_name   = "hub-p-law01"

##################################################################################
# ADDS network variables
##################################################################################
rg_name       = "adds-p-networking-rg01"
vnet_name     = "adds-p-vnet01"
address_space = ["172.20.6.0/24"]

subnets = {
  "adds-snet01" = {
    cidrs                           = ["172.20.6.0/28"]
    "create_network_security_group" = true
    "configure_nsg_rules"           = false
    "route_table_association"       = "adds-snet01-rt"
    # "dns-inbound-snet01" = {
    #   cidrs                           = ["172.20.6.16/28"]
    #   "create_network_security_group" = true
    #   "configure_nsg_rules"           = false
    #     # "dns-outbound-snet01" = {
    #   cidrs                           = ["172.20.6.32/28"]
    #   "create_network_security_group" = true
    #   "configure_nsg_rules"           = false
    #   
  }
}
route_tables = {
  adds-snet01-rt = {
    bgp_route_propagation_enabled = false
    use_inline_routes             = true # Setting to true will revert any external route additions.
    routes = {
      default = {
        "address_prefix"         = "0.0.0.0/0"
        "next_hop_type"          = "VirtualAppliance"
        "next_hop_in_ip_address" = "172.20.0.174"
      }
      vnet = {
        "address_prefix"         = "172.20.6.0/24"
        "next_hop_type"          = "VirtualAppliance"
        "next_hop_in_ip_address" = "172.20.0.174"
      }
    }
  }
}


peers = {
  "hb-p-HUB-vnet-01" = {
    id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/P-Networking-HUB-RG01/providers/Microsoft.Network/virtualNetworks/hb-p-HUB-vnet-01"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = true
  }
}

##################################################################################
# Test VM variables
##################################################################################
vm_rg_name = "adds-p-vm-rg01"
vm_name    = "ADDS-TEST"
username   = "azureuser"
password   = "PaloAlto123!"

