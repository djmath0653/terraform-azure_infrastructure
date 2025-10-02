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
  default = {}
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
# Connectivity network variables
##################################################################################
variable "rg_name" {
  type    = string
  default = "hub-vpn-networking-rg01"
}

variable "vnet_name" {
  type    = string
  default = "hub-vpn-vnet01"
}

variable "address_space" {
  type    = list(any)
  default = ["172.128.0.0/22"]
}

variable "subnets" {
  default = {
    "GatewaySubnet" = { cidrs = ["172.128.0.0/26"]  
    }
    "Route-Test" = { cidrs = ["172.128.0.64/26"]
    }
    # "fw-mgtmt-snet01" = { cidrs = ["172.128.0.128/28"]
    #   "create_network_security_group" = true
    #   "configure_nsg_rules"           = false
    # }
    # "fw-untrust-snet01" = { cidrs = ["172.128.0.144/28"]
    #   "create_network_security_group" = true
    #   "configure_nsg_rules"           = false
    # }
    # "fw-trust-snet01" = { cidrs = ["172.128.0.160/28"]
    #   "create_network_security_group" = true
    #   "configure_nsg_rules"           = false
    # }
    # "fw-ha-snet01" = { cidrs = ["172.128.0.176/28"]
    #   "create_network_security_group" = true
    #   "configure_nsg_rules"           = false
    # }
  }
}

variable "peers" {
  default = {
    # "gwy-vpn-vnet01" = {
    #   id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/gwy-vpn-networking-rg01/providers/Microsoft.Network/virtualNetworks/gwy-vpn-vnet01"
    #   allow_virtual_network_access = true
    #   allow_forwarded_traffic      = true
    #   allow_gateway_transit        = false
    #   use_remote_gateways          = true
    # }
    # "rsv-vpn-vnet01" = {
    #   id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/rsv-vpn-networking-rg01/providers/Microsoft.Network/virtualNetworks/rsv-vpn-vnet01"
    #   allow_virtual_network_access = true
    #   allow_forwarded_traffic      = false
    #   allow_gateway_transit        = false
    #   use_remote_gateways          = false
    # }
    # "adds-vpn-vnet01" = {
    #   id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/adds-vpn-networking-rg01/providers/Microsoft.Network/virtualNetworks/adds-vpn-vnet01"
    #   allow_virtual_network_access = true
    #   allow_forwarded_traffic      = true
    #   allow_gateway_transit        = false
    #   use_remote_gateways          = false
    # }
  }
}

##################################################################################
# Firewall variables
##################################################################################
variable "fw_rg_name" {
  type    = string
  default = "hub-vpn-firewalls-rg01"
}

variable "fw_vm_name" {
  type    = string
  default = "VPN-FW"
}

variable "username" {
  type    = string
  default = "azureuser"
}

variable "password" {
  type    = string
  default = "PaloAlto123!"
}

##################################################################################
# External Load Balancer variables
##################################################################################
variable "ext_lb_pip_name" {
  type    = string
  default = "hub-firewalls-elb01-pip01"
}

variable "ext_lb_name" {
  type    = string
  default = "hub-firewalls-elb01"
}

variable "int_lb_name" {
  type    = string
  default = "hub-firewalls-ilb01"
}

variable "frontend_private_ip_address" {
  type    = string
  default = "172.128.0.174"
}

##################################################################################
# Virtual Network Gateway variables
##################################################################################
variable "vng_rg_name" {
  type    = string
  default = "hub-vpn-vng-rg01"
}

variable "vpn_pip_name" {
  type    = string
  default = "gwy-vpn-vpn-pip"
}

variable "vpn_vng_name" {
  type    = string
  default = "gwy-vpn-vpn-vng"
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
  default = "gwy-vpn-vpn-lng"
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
  default = "gwy-vpn-vpn-lng-connection"
}

##################################################################################
# Route Server variables
##################################################################################
variable "route_server_name" {
  type    = string
  default = "rsv-vpn-rtsrvr01"
}

variable "route_server_public_ip_name" {
  type    = string
  default = "rsv-vpn-pip01"
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
  default = "172.128.0.164"
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
  default = "172.128.0.165"
}