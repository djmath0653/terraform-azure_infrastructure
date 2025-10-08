######################################################################################
# Global variables
######################################################################################

location             = "westus"
log_workspace_sub_id = "1cbd70a5-1547-4183-846f-12003f04578c"
log_workspace_rg     = "hub-p-logs-rg01"
log_workspace_name   = "hub-p-law01"

##################################################################################
# Connectivity network variables
##################################################################################
rg_name       = "DR-Networking-HUB-RG01"
vnet_name     = "hb-dr-HUB-vnet-01"
address_space = ["172.20.128.0/22"]
subnets = {
  "GatewaySubnet" = { cidrs = ["172.20.128.0/26"]
  }
  "palo-mgtmt-Subnet-01" = { cidrs = ["172.20.128.128/28"]
    "create_network_security_group" = true
    "configure_nsg_rules"           = false
  }
  "palo-untrust-Subnet-01" = { cidrs = ["172.20.128.144/28"]
    "create_network_security_group" = true
    "configure_nsg_rules"           = false
  }
  "palo-trust-Subnet-01" = { cidrs = ["172.20.128.160/28"]
    "create_network_security_group" = true
    "configure_nsg_rules"           = false
  }
  "palo-ha-Subnet-01" = { cidrs = ["172.20.128.176/28"]
    "create_network_security_group" = true
    "configure_nsg_rules"           = false
  }
}
peers = {
  "hb-dr-PANO-vnet-01" = {
    id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/DR-Networking-PANO-RG01/providers/Microsoft.Network/virtualNetworks/hb-dr-PANO-vnet-01"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = true
    use_remote_gateways          = false
  }
  "adds-dr-vnet01" = {
    id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/adds-dr-networking-rg01/providers/Microsoft.Network/virtualNetworks/adds-dr-vnet01"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = true
    use_remote_gateways          = false
  }
}

##################################################################################
# Firewall variables
##################################################################################
fw_rg_name     = "DR-PALO-RG01"
fw_vm_name     = "AZU-PPALO01"
username       = "azureuser"
password       = "PaloAlto123!"
fw_mgmt_nic    = ["172.20.128.132", "172.20.128.133"]
fw_untrust_nic = ["172.20.128.148", "172.20.128.149"]
fw_trust_nic   = ["172.20.128.164", "172.20.128.165"]
fw_ha_nic      = ["172.20.128.180", "172.20.128.181"]

##################################################################################
# External Load Balancer variables
##################################################################################
ext_lb_pip_name             = "lb-palo-elb01-pip01"
ext_lb_name                 = "lb-palo-elb01"
int_lb_nameb                = "lb-palo-ilb01"
frontend_private_ip_address = "172.20.128.174"

##################################################################################
# Virtual Network Gateway variables
##################################################################################
vpn_pip_name         = "gwy-vpn-dr-pip"
vpn_vng_name         = "gwy-vpn-dr-vng"
vpn_vng_sku          = "VpnGw1"
vpn_vng_type         = "Vpn"
vpn_lng_name         = "gwy-vpn-dr-lng"
vpn_lng_ip_addess    = "73.50.100.28"
vpn_lng_addess_space = ["192.168.0.0/16"]
vpn_connection_name  = "gwy-vpn-dr-lng-connection"

##################################################################################
# ExpressRoute Gateway variables
##################################################################################
er_pip_name  = "gwy-er-dr-pip"
er_vng_nameb = "gwy-er-dr-vng"
er_vng_sku   = "Standard"
er_vng_type  = "ExpressRoute"

