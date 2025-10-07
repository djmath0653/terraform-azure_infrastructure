##################################################################################
# Fierewall VMs
##################################################################################
module "pano_resource_group" {
  source = "../../modules/arm_resource_group"

  name     = var.pano_rg_name
  location = var.location
  tags     = var.tags
}

# This is the module call
module "pano_public_ip_address" {
  source = "../../modules/arm_public_ip_address"
  count  = 2

  name                = "${var.pano_vm_name}-0${count.index + 1}-pip"
  resource_group_name = module.pano_resource_group.name
  location            = module.pano_resource_group.location
  zones               = [count.index + 1]
  diagnostic_settings = {
    diag = {
      workspace_resource_id = local.workspace_resource_id
    }
  }
}

module "firewall_pair" {
  source = "../../modules/arm_virtual_machine"
  count  = 1

  name                = "${var.pano_vm_name}-0${count.index + 1}"
  resource_group_name = module.pano_resource_group.name
  location            = module.pano_resource_group.location
  zone                = count.index + 1
  sku_size            = "Standard_DS3_v2"
  os_type             = "Linux"
  source_image_reference = ({
    publisher = "paloaltonetworks"
    offer     = "panorama"
    sku       = "byol"
    version   = "11.1.607"
  })
  plan = ({
    name      = "byol"
    product   = "panorama"
    publisher = "paloaltonetworks"
  })
  account_credentials = {
    admin_credentials = {
      username                           = var.username
      password                           = var.password
      generate_admin_password_or_ssh_key = false
    }
    password_authentication_disabled = false
  }
  network_interfaces = {
    network_interface_0 = {
      name                           = "${var.pano_vm_name}-0${count.index + 1}-nic0"
      accelerated_networking_enabled = true
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1-${module.virtual_network.subnet["pano-mgtmt-snet01"].name}"
          private_ip_subnet_resource_id = module.virtual_network.subnet["pano-mgtmt-snet01"].id
          private_ip_address            = "172.20.4.0${count.index + 4}"
          private_ip_address_allocation = "Static"
        }
      }
      diagnostic_settings = {
        diag = {
          name                  = "diag-${var.pano_vm_name}-0${count.index + 1}-nic0"
          workspace_resource_id = local.workspace_resource_id
        }
      }
    }
  
  }
}
