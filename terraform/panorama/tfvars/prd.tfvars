######################################################################################
# Global variables
######################################################################################
location             = "eastus"
log_workspace_sub_id = "1cbd70a5-1547-4183-846f-12003f04578c"
log_workspace_rg     = "hub-p-logs-rg01"
log_workspace_name   = "hub-p-law01"

##################################################################################
# Connectivity network variables
##################################################################################
rg_name       = "P-Networking-PANO-RG01"
vnet_name     = "hb-p-PANO-vnet-01"
address_space = ["172.20.4.0/24"]
subnets = {
  "pano-mgtmt-snet01" = { 
    cidrs = ["172.20.4.0/26"]
    "create_network_security_group" = true
    "configure_nsg_rules"           = false
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
# Panorama variables
##################################################################################
pano_rg_name = "P-PANO-RG01"
pano_vm_name = "AZU-PPANO01"
username     = "azureuser"
password     = "PaloAlto123!"
