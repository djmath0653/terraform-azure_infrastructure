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

##################################################################################
# Route Server network variables
##################################################################################
variable "rg_name" {
  type    = string
  default = "rsv-p-networking-rg01"
}

variable "vnet_name" {
  type    = string
  default = "rsv-p-vnet01"
}

variable "address_space" {
  type    = list(any)
  default = ["172.20.5.0/24"]
}

variable "subnets" {
  default = {
    "RouteServerSubnet" = { cidrs = ["172.20.5.0/26"]
    }
  }
}

variable "peers" {
  default = {
    # "hub-p-vnet01" = {
    #   id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/hub-p-networking-rg01/providers/Microsoft.Network/virtualNetworks/hub-p-vnet01"
    #   allow_virtual_network_access = true
    #   allow_forwarded_traffic      = false
    #   allow_gateway_transit        = false
    #   use_remote_gateways          = false
    # }
    # "adds-p-vnet01" = {
    #   id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/adds-p-networking-rg01/providers/Microsoft.Network/virtualNetworks/adds-p-vnet01"
    #   allow_virtual_network_access = true
    #   allow_forwarded_traffic      = false
    #   allow_gateway_transit        = true
    #   use_remote_gateways          = false
    # }
  }
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

