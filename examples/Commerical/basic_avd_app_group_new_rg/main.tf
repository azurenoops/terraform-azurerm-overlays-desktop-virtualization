# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Terraform module for deploying a basic Azure Desktop with Application Group in Azure. 

module "mod_avd" {
  #source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  #version = "x.x.x"
  source = "../../.."

  depends_on = [
    azurerm_log_analytics_workspace.avd-log,
  ]

  # Resource Group, location, VNet and Subnet details
  create_avd_resource_group = true
  location                  = var.location
  deploy_environment        = var.deploy_environment
  environment               = var.environment
  org_name                  = var.org_name
  workload_name             = var.workload_name

  # AVD Workspace details
  avd_workspace_config = {
    public_network_access_enabled         = false
    enable_private_endpoint               = true
    existing_private_resource_group_name  = azurerm_resource_group.avd-network-rg.name
    existing_private_virtual_network_name = azurerm_virtual_network.avd-vnet.name
    existing_private_subnet_name          = azurerm_subnet.avd-snet.name
    add_tags = {
      foo = "bar"
    }
  }

  # AVD Host Pool details
  avd_host_pool_config = {
    # Value will automatically change depending on the Scaling Plan settings
    load_balancer_type = "BreadthFirst"

    scheduled_agent_updates = {
      enabled = true
      schedules = [
        {
          day_of_week = "Sunday"
          hour_of_day = 8
        },
        {
          day_of_week = "Wednesday"
          hour_of_day = 22
        },
      ]
    }
  }

  # AVD Application Group details
  avd_application_group_config = {
    type = "Desktop"
  }

  avd_vm_config = {
    windows2019 = {
      os_type                                      = "windows"
      distribution_name                            = "windows2019dc"
      virtual_machine_size                         = "Standard_D13_v2"
      disable_password_authentication              = true
      aad_group_desktop                            = "SG-AVD-PersonalDesktop-Users"
      admin_username                               = "azureuser"
      admin_password                               = "P@ssw0rd1234"
      instances_count                              = 20
      private_ip_address_allocation_type           = "Dynamic"
      existing_virtual_network_resource_group_name = azurerm_resource_group.avd-network-rg.name
      existing_virtual_network_name                = azurerm_virtual_network.avd-vnet.name
      existing_subnet_name                         = azurerm_subnet.avd-snet.name
      existing_network_security_group_name         = azurerm_network_security_group.avd-nsg.name
      nsg_inbound_rules = [
        {
          name                       = "RDP"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3389"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "HTTP"
          priority                   = 101
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "HTTPS"
          priority                   = 102
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
      ]
      data_disks = [
        {
          name                 = "disk1"
          disk_size_gb         = 100
          storage_account_type = "StandardSSD_LRS"
        }
      ]
      add_tags = {
        foo = "windows2019"
      }
    }
  }

  # Adding additional TAG's to your Azure resources
  add_tags = {
    Example = "basic_avd_app_group_new_rg"
  }
}
