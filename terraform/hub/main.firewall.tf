##################################################################################
# Fierewall VMs
##################################################################################
module "fw_resource_group" {
  source = "../../modules/arm_resource_group"

  name     = var.fw_rg_name
  location = var.location
  tags     = var.tags
}

# This is the module call
module "fw_public_ip_address" {
  source = "../../modules/arm_public_ip_address"
  count  = 2

  name                = "${var.fw_vm_name}-0${count.index + 1}-pip"
  resource_group_name = module.fw_resource_group.name
  location            = module.fw_resource_group.location
  zones               = [count.index + 1]
  diagnostic_settings = {
    diag = {
      workspace_resource_id = local.workspace_resource_id
    }
  }
}

module "firewall_pair" {
  source = "../../modules/arm_virtual_machine"
  count  = 2

  name                = "${var.fw_vm_name}-0${count.index + 1}"
  resource_group_name = module.fw_resource_group.name
  location            = module.fw_resource_group.location
  zone                = count.index + 1
  sku_size            = "Standard_DS3_v2"
  os_type             = "Linux"
  source_image_reference = ({
    publisher = "paloaltonetworks"
    offer     = "vmseries-flex"
    sku       = "bundle2"
    version   = "11.1.607"
  })
  plan = ({
    name      = "bundle2"
    product   = "vmseries-flex"
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
      name                           = "${var.fw_vm_name}-0${count.index + 1}-nic0"
      accelerated_networking_enabled = true
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1-${module.virtual_network.subnet["palo-mgtmt-Subnet-01"].name}"
          private_ip_subnet_resource_id = module.virtual_network.subnet["palo-mgtmt-Subnet-01"].id
          private_ip_address            = "172.20.0.13${count.index + 2}"
          private_ip_address_allocation = "Static"
        }
      }
      diagnostic_settings = {
        diag = {
          name                  = "diag-${var.fw_vm_name}-0${count.index + 1}-nic1"
          workspace_resource_id = local.workspace_resource_id
        }
      }
    }
    network_interface_1 = {
      name                           = "${var.fw_vm_name}-0${count.index + 1}-nic1"
      accelerated_networking_enabled = true
      ip_forwarding_enabled          = true
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1-${module.virtual_network.subnet["palo-untrust-Subnet-01"].name}"
          private_ip_subnet_resource_id = module.virtual_network.subnet["palo-untrust-Subnet-01"].id
          private_ip_address            = "172.20.0.14${count.index + 8}"
          private_ip_address_allocation = "Static"
          public_ip_address_resource_id = module.fw_public_ip_address[count.index].resource_id
        }
      }
      diagnostic_settings = {
        diag = {
          name                  = "diag-${var.fw_vm_name}-0${count.index + 1}-nic1"
          workspace_resource_id = local.workspace_resource_id
        }
      }
    }
    network_interface_2 = {
      name                           = "${var.fw_vm_name}-0${count.index + 1}-nic2"
      accelerated_networking_enabled = true
      ip_forwarding_enabled          = true
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1-${module.virtual_network.subnet["palo-trust-Subnet-01"].name}"
          private_ip_subnet_resource_id = module.virtual_network.subnet["palo-trust-Subnet-01"].id
          private_ip_address            = "172.20.0.16${count.index + 4}"
          private_ip_address_allocation = "Static"
        }
      }
      diagnostic_settings = {
        diag = {
          name                  = "diag-${var.fw_vm_name}-0${count.index + 1}-nic2"
          workspace_resource_id = local.workspace_resource_id
        }
      }
    }
    network_interface_3 = {
      name                           = "${var.fw_vm_name}-0${count.index + 1}-nic3"
      accelerated_networking_enabled = true
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1-${module.virtual_network.subnet["palo-ha-Subnet-01"].name}"
          private_ip_subnet_resource_id = module.virtual_network.subnet["palo-ha-Subnet-01"].id
          private_ip_address            = "172.20.0.18${count.index}"
          private_ip_address_allocation = "Static"
        }
      }
      diagnostic_settings = {
        diag = {
          name                  = "diag-${var.fw_vm_name}-0${count.index + 1}-nic3"
          workspace_resource_id = local.workspace_resource_id
        }
      }
    }
  }
}
