# Azure Virtual Desktop Overlay Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-desktop-virtualization/azurerm/)

This Overlay terraform module can create a an [Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/avd/) and manage related components (Host Pools, App Scaling Plans, etc.) to be used in a [SCCA compliant Network](https://registry.terraform.io/modules/azurenoops/overlays-management-hub/azurerm/latest).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Using Azure Clouds

Since this module is built for both public and us government clouds. The `environment` variable defaults to `public` for Azure Cloud. When using this module with the Azure Government Cloud, you must set the `environment` variable to `usgovernment`. You will also need to set the azurerm provider `environment` variable to the proper cloud as well. This will ensure that the correct Azure Government Cloud endpoints are used. You will also need to set the `location` variable to a valid Azure Government Cloud location.

Example Usage for Azure Government Cloud:

```hcl

provider "azurerm" {
  environment = "usgovernment"
}

module "mod_avd" {
  source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  version = "x.x.x"
  
  location = "usgovvirginia"
  environment = "usgovernment"
  ...
}

```

## Resources Used

* [Azure Virtual Desktop Workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azure_virtual_desktop_workspace)
* [Azure Virtual Desktop Host Pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azure_virtual_desktop_host_pool)
* [Azure Virtual Desktop Application Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azure_virtual_desktop_application_group)
* [Azure Virtual Desktop Application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azure_virtual_desktop_application)
* [Linux Virtual Machine](https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine.html)
* [Windows Virtual Machine](https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html)
* [Boot Diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine#boot_diagnostics)
* [Proximity Placement Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/proximity_placement_group)
* [Availability Set](https://www.terraform.io/docs/providers/azurerm/r/availability_set.html)
* [Public IP](https://www.terraform.io/docs/providers/azurerm/r/public_ip.html)
* [Network Security Group](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)
* [Managed Identities](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine#identity)
* [Custom Data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine#custom_data)
* [Additional_Unattend_Content](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine#additional_unattend_content)
* [SSH2 Key generation for Dev Environments](https://www.terraform.io/docs/providers/tls/r/private_key.html)
* [Azure Monitoring Diagnostics](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
* [Azure Resource Locks](https://www.terraform.io/docs/providers/azurerm/r/management_lock.html)

## Overlay Module Usage

### AVD Workspace

The Azure Virtual Desktop Workspace is a logical grouping of application groups in Azure Virtual Desktop. Each Azure Virtual Desktop application group must be associated with a workspace for users to see the desktops and applications published to them.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "mod_avd" {
  source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  version = "x.x.x"

# .... omitted
  
   # AVD Workspace details
  avd_workspace_config = {
    public_network_access_enabled = false
    add_tags = {
      foo = "bar"
    }
  }

# .... omitted 

}
```

### AVD Host Pool

The Azure Virtual Desktop Host Pool is a collection of Azure virtual machines that register to Azure Virtual Desktop as session hosts when you run the Azure Virtual Desktop agent. All session host virtual machines in a host pool should be sourced from the same image for a consistent user experience. You control the resources published to users through application groups.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "mod_avd" {
  source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  version = "x.x.x"

# .... omitted
  
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

# .... omitted 

}
```

### AVD Application Group

The Azure Virtual Desktop Application Group is a logical grouping of applications installed on session hosts in the host pool.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "mod_avd" {
  source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  version = "x.x.x"

# .... omitted
  
   # AVD Application Group details
  avd_application_group_config = {
    type = "Desktop"
  }

# .... omitted

}
```

### AVD Virtual Machine

The Azure Virtual Desktop Virtual Machine is a virtual machine that is used to host the users' desktops and applications. The virtual machine is used to manage the users that can access the virtual machine.

> NOTE: This module uses the Azure NoOps Virtual Machine Overlay module to create the virtual machines. For more information on how to use the parameters in this module, please see the [Azure NoOps Virtual Machine Overlay module](https://registry.terraform.io/modules/azurenoops/overlays-virtual-machine/azurerm/latest). Some parameters are not used in this module.

#### Windows Virtual Machine

The Windows Virtual Machine is a virtual machine that is used to host the users' desktops and applications. The virtual machine is used to manage the users that can access the virtual machine.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

# .... omitted

module "mod_avd" {
  source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  version = "x.x.x"
  
  # .... omitted

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

# .... omitted

}
```

#### Linux Virtual Machine

The Linux Virtual Machine is a virtual machine that is used to host the users' desktops and applications. The virtual machine is used to manage the users that can access the virtual machine.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

# .... omitted

module "mod_avd" {
  source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  version = "x.x.x"
  
  # .... omitted

  avd_vm_config = {
    ubuntu2004 = {
      os_type                                      = "linux"
      distribution_name                            = "ubuntu2004"
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
          name                       = "SSH"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
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
      add_tags
      add_tags = {
        foo = "ubuntu2004"
      }

    }
  }

# .... omitted

}
```

### AVD Application

The Azure Virtual Desktop Application is a remote application that is used to host the users' applications.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

# .... omitted

module "mod_avd" {
  source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  version = "x.x.x"
  
  # .... omitted

  avd_application_config = {
    notepad = {
      application_group_name = "AG-Notepad"
      friendly_name          = "Notepad"
      description            = "Notepad"
      command_line_argument  = "notepad.exe"
      path                   = "C:\\Windows\\System32\\notepad.exe"
      icon_path              = "C:\\Windows\\System32\\notepad.exe"
      icon_index             = 0
      show_in_portal         = true
      add_tags = {
        foo = "notepad"
      }
    }
  }

# .... omitted

}
```

### AVD Workspace Role Assignment

The Azure Virtual Desktop Workspace Role Assignment is a role assignment that is used to assign users to the Azure Virtual Desktop Workspace.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

# .... omitted

module "mod_avd" {
  source  = "azurenoops/overlays-desktop-virtualization/azurerm"
  version = "x.x.x"
  
  # .... omitted

  avd_workspace_role_assignment_config = {
    desktop_users = {
      role_definition_name = "Virtual Machine User Login"
      principal_id         = data.azurerm_user_assigned_identity.avd-identity.principal_id
    }
  }

# .... omitted
  
  }
```

### AVD Shared Image (Coming Soon)

The Azure Virtual Desktop Shared Image is a shared image that is used to create the Azure Virtual Desktop Virtual Machines.

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

# .... omitted

```

## Optional Features

Azure Virtual Desktop Overlay has optional features that can be enabled by setting parameters on the deployment.

## Create resource group

By default, this module will create a resource group and the name of the resource group to be given in an argument `existing_resource_group_name`. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_avd_resource_group = false`.

> *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Resource Locks

This module can be used with the [Resource Lock Module](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) to create resource locks for the Synapse workspace.

## Recommended naming and tagging conventions

Applying tags to your Azure resources, resource groups, and subscriptions to logically organize them into a taxonomy. Each tag consists of a name and a value pair. For example, you can apply the name `Environment` and the value `Production` to all the resources in production.
For recommendations on how to implement a tagging strategy, see Resource naming and tagging decision guide.

>**Important** :
Tag names are case-insensitive for operations. A tag with a tag name, regardless of the casing, is updated or retrieved. However, the resource provider might keep the casing you provide for the tag name. You'll see that casing in cost reports. **Tag values are case-sensitive.**

An effective naming convention assembles resource names by using important resource information as parts of a resource's name. For example, using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names), a public IP resource for a production SharePoint workload is named like this: `pip-sharepoint-prod-westus-001`.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.47 |
| <a name="requirement_azurenoopsutils"></a> [azurenoopsutils](#requirement\_azurenoopsutils) | ~> 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.69 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.47 |
| <a name="provider_azurenoopsutils"></a> [azurenoopsutils](#provider\_azurenoopsutils) | ~> 1.0.4 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.69 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.10 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mod_azure_region_lookup"></a> [mod\_azure\_region\_lookup](#module\_mod\_azure\_region\_lookup) | azurenoops/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| <a name="module_mod_scaffold_rg"></a> [mod\_scaffold\_rg](#module\_mod\_scaffold\_rg) | azurenoops/overlays-resource-group/azurerm | ~> 1.0.1 |
| <a name="module_mod_virtual_machine"></a> [mod\_virtual\_machine](#module\_mod\_virtual\_machine) | azurenoops/overlays-virtual-machine/azurerm | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.azurerm_virtual_desktop_host_pool_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.azurerm_virtual_desktop_workspace_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_role_assignment.rbac](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.scaling_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.scaling_role_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_virtual_desktop_application.application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application) | resource |
| [azurerm_virtual_desktop_application_group.app_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_host_pool.pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_virtual_desktop_host_pool_registration_info.host_pool_registration_info](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool_registration_info) | resource |
| [azurerm_virtual_desktop_scaling_plan.scaling_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan) | resource |
| [azurerm_virtual_desktop_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.workspace_app_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |
| [time_rotating.time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azuread_group.aad_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.avd_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurenoopsutils_resource_name.avd_application_group](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.avd_host_pool](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.avd_scaling_plan](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.avd_workspace](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_role_definition.avduser_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_group_desktop"></a> [aad\_group\_desktop](#input\_aad\_group\_desktop) | The desktop pool's assignment AAD group. Required if var.avd\_host\_pool\_config.type != application. | `string` | `null` | no |
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Map of custom tags. | `map(string)` | `{}` | no |
| <a name="input_avd_application_config"></a> [avd\_application\_config](#input\_avd\_application\_config) | AVD Application specific configuration. | <pre>map(object({<br>    app_name                     = optional(string)<br>    friendly_name                = optional(string)<br>    description                  = optional(string)<br>    path                         = optional(string)<br>    command_line_arguments       = optional(string)<br>    show_in_portal               = optional(bool, false)<br>    icon_path                    = optional(string)<br>    icon_index                   = optional(number)<br>    aad_group                    = optional(string)<br>    add_tags                     = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_avd_application_group_config"></a> [avd\_application\_group\_config](#input\_avd\_application\_group\_config) | AVD Application Group specific configuration. | <pre>object({<br>    type                         = optional(string, "Desktop")<br>    add_tags                     = optional(map(string))<br>  })</pre> | `null` | no |
| <a name="input_avd_host_pool_config"></a> [avd\_host\_pool\_config](#input\_avd\_host\_pool\_config) | AVD Host Pool specific configuration. | <pre>object({<br>    friendly_name                         = optional(string)<br>    description                           = optional(string)<br>    validate_environment                  = optional(bool, true)<br>    custom_rdp_properties                 = optional(string, "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;")<br>    type                                  = optional(string, "Pooled")<br>    load_balancer_type                    = optional(string, "DepthFirst")<br>    personal_desktop_assignment_type      = optional(string, "Automatic")<br>    maximum_sessions_allowed              = optional(number, 16)<br>    preferred_app_group_type              = optional(string)<br>    host_registration_expires_in_in_hours = optional(number, 48)<br>    scheduled_agent_updates = optional(object({<br>      enabled                   = optional(bool, false)<br>      timezone                  = optional(string, "UTC") # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/<br>      use_session_host_timezone = optional(bool, false)<br>      schedules = optional(list(object({<br>        day_of_week = string<br>        hour_of_day = number<br>      })), [])<br>    }), {})<br>    add_tags = optional(map(string))<br>  })</pre> | `{}` | no |
| <a name="input_avd_shared_image"></a> [avd\_shared\_image](#input\_avd\_shared\_image) | AVD Shared Image specific configuration. | <pre>object({<br>    sig_image_name = optional(string)<br>    os_type        = optional(string)<br>    identifier = optional(object({<br>      publisher = optional(string)<br>      offer     = optional(string)<br>      sku       = optional(string)<br>    }))<br>  })</pre> | `{}` | no |
| <a name="input_avd_vm_config"></a> [avd\_vm\_config](#input\_avd\_vm\_config) | AVD Virtual Machine configuration. | <pre>map(object({<br>    distribution_name                            = optional(string, "windows2019dc")<br>    virtual_machine_size                         = optional(string, "standard_d2as_v4")<br>    aad_group_desktop                            = optional(string, null)<br>    os_type                                      = optional(string, "Windows")<br>    disable_password_authentication              = optional(bool, false)<br>    admin_ssh_key_data                           = optional(string, null)<br>    admin_username                               = optional(string, "azureadmin")<br>    admin_password                               = optional(string, null)<br>    instances_count                              = optional(number, 0)<br>    enable_proximity_placement_group             = optional(bool, false)<br>    enable_vm_availability_set                   = optional(bool, false)<br>    enable_public_ip_address                     = optional(bool, false)<br>    enable_automatic_updates                     = optional(bool, false)<br>    existing_network_security_group_name         = optional(string, null)<br>    license_type                                 = optional(string, "None")<br>    private_ip_address_allocation_type           = optional(string, "Dynamic")<br>    private_ip_address                           = optional(list(string), null)<br>    existing_virtual_network_name                = optional(string, null)<br>    existing_virtual_network_resource_group_name = optional(string, null)<br>    existing_subnet_name                         = optional(string, null)<br>    source_image_id                              = optional(string, null)<br>    custom_data                                  = optional(string, null)<br>    custom_image = optional(object({<br>      name      = string<br>      product   = string<br>      publisher = string<br>      plan = object({<br>        name      = string<br>        product   = string<br>        publisher = string<br>      })<br>    }), null)<br>    nsg_inbound_rules = optional(list(object({<br>      name                   = optional(string)<br>      destination_port_range = optional(string)<br>      source_address_prefix  = optional(string)<br>    })), [])<br>    enable_boot_diagnostics = optional(bool, false)<br>    data_disks = optional(list(object({<br>      name                      = optional(string)<br>      caching                   = optional(string)<br>      create_option             = optional(string)<br>      disk_size_gb              = optional(number)<br>      lun                       = optional(number)<br>      managed_disk_type         = optional(string)<br>      storage_account_type      = optional(string)<br>      write_accelerator_enabled = optional(bool)<br>    })), [])<br>    deploy_log_analytics_agent                 = optional(bool, false)<br>    log_analytics_workspace_id                 = optional(string, null)<br>    log_analytics_customer_id                  = optional(string, null)<br>    log_analytics_workspace_primary_shared_key = optional(string, null)<br>    add_tags                                   = optional(map(string))<br>  }))</pre> | `null` | no |
| <a name="input_avd_workspace_config"></a> [avd\_workspace\_config](#input\_avd\_workspace\_config) | AVD Workspace specific configuration. | <pre>object({<br>    friendly_name                 = optional(string)<br>    description                   = optional(string)<br>    public_network_access_enabled = optional(bool)<br>    add_tags                      = optional(map(string))<br>  })</pre> | `{}` | no |
| <a name="input_create_avd_resource_group"></a> [create\_avd\_resource\_group](#input\_create\_avd\_resource\_group) | Create a resource group for the AVD Workspace. If set to false, the existing\_resource\_group\_name variable must be set. Default is false. | `bool` | `false` | no |
| <a name="input_custom_application_group_custom_name"></a> [custom\_application\_group\_custom\_name](#input\_custom\_application\_group\_custom\_name) | Custom Azure Virtual Desktop Application Group name, generated if not set. | `string` | `""` | no |
| <a name="input_custom_host_pool_custom_name"></a> [custom\_host\_pool\_custom\_name](#input\_custom\_host\_pool\_custom\_name) | Custom Azure Virtual Desktop host pool name, generated if not set. | `string` | `""` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_scaling_plan_custom_name"></a> [custom\_scaling\_plan\_custom\_name](#input\_custom\_scaling\_plan\_custom\_name) | Custom Azure Virtual Desktop Scaling Plan name, generated if not set. | `string` | `""` | no |
| <a name="input_custom_workspace_custom_name"></a> [custom\_workspace\_custom\_name](#input\_custom\_workspace\_custom\_name) | Custom Azure Virtual Desktop workspace name, generated if not set. | `string` | `""` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | Name of the workload's environment | `string` | n/a | yes |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | (Optional) Enable resource locks, default is false. If true, resource locks will be created for the resource group and the storage account. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which instance will be hosted | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Name of the organization | `string` | n/a | yes |
| <a name="input_scaling_plan_config"></a> [scaling\_plan\_config](#input\_scaling\_plan\_config) | AVD Scaling Plan specific configuration. | <pre>object({<br>    enabled       = optional(bool, false)<br>    friendly_name = optional(string)<br>    description   = optional(string)<br>    exclusion_tag = optional(string)<br>    timezone      = optional(string, "UTC") # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/<br>    schedules = optional(list(object({<br>      name                                 = string<br>      days_of_week                         = list(string)<br>      peak_start_time                      = string<br>      peak_load_balancing_algorithm        = optional(string, "BreadthFirst")<br>      off_peak_start_time                  = string<br>      off_peak_load_balancing_algorithm    = optional(string, "DepthFirst")<br>      ramp_up_start_time                   = string<br>      ramp_up_load_balancing_algorithm     = optional(string, "BreadthFirst")<br>      ramp_up_capacity_threshold_percent   = optional(number, 75)<br>      ramp_up_minimum_hosts_percent        = optional(number, 33)<br>      ramp_down_start_time                 = string<br>      ramp_down_capacity_threshold_percent = optional(number, 5)<br>      ramp_down_force_logoff_users         = optional(string, false)<br>      ramp_down_load_balancing_algorithm   = optional(string, "DepthFirst")<br>      ramp_down_minimum_hosts_percent      = optional(number, 33)<br>      ramp_down_notification_message       = optional(string, "Please log off in the next 45 minutes...")<br>      ramp_down_stop_hosts_when            = optional(string, "ZeroSessions")<br>      ramp_down_wait_time_minutes          = optional(number, 45)<br>    })), [])<br>    role_assignment = optional(object({<br>      enabled      = optional(bool, true)<br>      principal_id = optional(string)<br>    }), {})<br>    add_tags = optional(map(string))<br>  })</pre> | `{}` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `false` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload\_name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_groups"></a> [application\_groups](#output\_application\_groups) | AVD Application Group object output. |
| <a name="output_avd_service_principal_client_id"></a> [avd\_service\_principal\_client\_id](#output\_avd\_service\_principal\_client\_id) | AVD Service Principal Client ID (Application ID). |
| <a name="output_avd_service_principal_name"></a> [avd\_service\_principal\_name](#output\_avd\_service\_principal\_name) | AVD Service Principal name. |
| <a name="output_avd_service_principal_object_id"></a> [avd\_service\_principal\_object\_id](#output\_avd\_service\_principal\_object\_id) | AVD Service Principal Object ID (Principal ID). |
| <a name="output_host_pool"></a> [host\_pool](#output\_host\_pool) | AVD Host Pool object output. |
| <a name="output_host_pool_id"></a> [host\_pool\_id](#output\_host\_pool\_id) | AVD Host Pool ID. |
| <a name="output_host_pool_name"></a> [host\_pool\_name](#output\_host\_pool\_name) | AVD Host Pool name. |
| <a name="output_host_registration_token"></a> [host\_registration\_token](#output\_host\_registration\_token) | AVD host registration token. |
| <a name="output_host_registration_token_expiration_date"></a> [host\_registration\_token\_expiration\_date](#output\_host\_registration\_token\_expiration\_date) | AVD host registration token expiration date. |
| <a name="output_scaling_plan"></a> [scaling\_plan](#output\_scaling\_plan) | AVD Scaling Plan object output. |
| <a name="output_scaling_plan_id"></a> [scaling\_plan\_id](#output\_scaling\_plan\_id) | AVD Scaling Plan ID. |
| <a name="output_scaling_plan_name"></a> [scaling\_plan\_name](#output\_scaling\_plan\_name) | AVD Scaling Plan name. |
| <a name="output_scaling_plan_role_definition"></a> [scaling\_plan\_role\_definition](#output\_scaling\_plan\_role\_definition) | AVD Scaling Plan Role Definition object output. |
| <a name="output_scaling_plan_role_definition_id"></a> [scaling\_plan\_role\_definition\_id](#output\_scaling\_plan\_role\_definition\_id) | AVD Scaling Plan Role Definition ID. |
| <a name="output_scaling_plan_role_definition_name"></a> [scaling\_plan\_role\_definition\_name](#output\_scaling\_plan\_role\_definition\_name) | AVD Scaling Plan Role Definition name. |
| <a name="output_workspace"></a> [workspace](#output\_workspace) | AVD Workspace object output. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | AVD Workspace ID. |
| <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name) | AVD Workspace name. |
<!-- END_TF_DOCS -->