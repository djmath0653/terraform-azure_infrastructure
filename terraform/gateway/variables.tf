######################################################################################
# Global variables
######################################################################################
variable "subscription_id" {
  type    = string
  default = "1cbd70a5-1547-4183-846f-12003f04578c"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "tags" {
  type    = map(string)
  default = {
    tag = "test"
  }
}

variable "log_workspace_rg" {
  type = string
  default = "hub-p-logs-rg01"
}

variable "log_workspace_name" {
  type = string
  default = "hub-p-law01"
}

##################################################################################
# Gateway network variables
##################################################################################
variable "rg_name" {
  type    = string
  default = "gwy-p-networking-rg01"
}

variable "vnet_name" {
  type    = string
  default = "gwy-p-vnet01"
}

variable "address_space" {
  type    = list(any)
  default = ["172.20.4.0/24"]
}

variable "subnets" {
  default = {
    "GatewaySubnet" = {
      cidrs = ["172.20.4.0/26"]
    }
    "RouteServerSubnet" = {
      cidrs = ["172.20.4.64/26"]
    }
    "testing" = {
      cidrs = ["172.20.4.128/26"]
      "route_table_association"       = "gwy-p-vnet01-rt"
    }
  }
}

variable "route_tables" {
  description = "Maps of route tables"
  type        = map(any)
  default = {
    gwy-p-vnet01-rt = {
      bgp_route_propagation_enabled = false
      use_inline_routes             = true # Setting to true will revert any external route additions.
      routes = {
      }
    }
    # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route
  }
}

# variable "peers" {
#   default = {}
# }

variable "peers" {
  default = {
    "hub-p-vnet01" = {
      id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/hub-p-networking-rg01/providers/Microsoft.Network/virtualNetworks/hub-p-vnet01"
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = true
      use_remote_gateways          = false
    }
  }
}
##################################################################################
# Virtual Network Gateway variables
##################################################################################

variable "vpn_pip_name" {
  type    = string
  default = "gwy-vpn-p-pip"
}

variable "vpn_vng_name" {
  type    = string
  default = "gwy-vpn-p-vng"
}

variable "vpn_vng_sku" {
  type    = string
  default = "VpnGw1"
}

variable "vpn_vng_type" {
  type    = string
  default = "Vpn"
}

variable "vpn_lng_name" {
  type    = string
  default = "gwy-vpn-p-lng"
}

variable "vpn_lng_ip_addess" {
  type    = string
  default = "73.50.100.28"
}

variable "vpn_lng_addess_space" {
  type    = list(string)
  default = ["192.168.0.0/16"]
}

variable "vpn_connection_name" {
  type    = string
  default = "gwy-vpn-p-lng-connection"
}


##################################################################################
# ExpressRoute Gateway variables
##################################################################################

variable "er_pip_name" {
  type    = string
  default = "gwy-er-p-pip"
}

variable "er_vng_name" {
  type    = string
  default = "gwy-er-p-vng"
}

variable "er_vng_sku" {
  type    = string
  default = "Standard"
}

variable "er_vng_type" {
  type    = string
  default = "ExpressRoute"
}


##################################################################################
# Route Server variables
##################################################################################
variable "route_server_name" {
  type    = string
  default = "rsv-p-rtsrvr01"
}

variable "route_server_public_ip_name" {
  type    = string
  default = "rsv-p-pip"
}

variable "route_server_peer_1_name" {
  type    = string
  default = "P-FW-01-peer"
}

variable "route_server_peer_1_asn" {
  type    = string
  default = "65432"
}

variable "route_server_peer_1_ip" {
  type    = string
  default = "172.20.0.164"
}

variable "route_server_peer_2_name" {
  type    = string
  default = "P-FW-02-peer"
}

variable "route_server_peer_2_asn" {
  type    = string
  default = "65432"
}

variable "route_server_peer_2_ip" {
  type    = string
  default = "172.20.0.165"
}