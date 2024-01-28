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

### AVD Shared Image (Comming Soon)

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
| <a name="requirement_azurenoopsutils"></a> [azurenoopsutils](#requirement\_azurenoopsutils) | ~> 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurenoopsutils"></a> [azurenoopsutils](#provider\_azurenoopsutils) | ~> 1.0.4 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.36 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mod_azure_region_lookup"></a> [mod\_azure\_region\_lookup](#module\_mod\_azure\_region\_lookup) | azurenoops/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| <a name="module_mod_scaffold_rg"></a> [mod\_scaffold\_rg](#module\_mod\_scaffold\_rg) | azurenoops/overlays-resource-group/azurerm | ~> 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.workspace_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_management_lock.resource_group_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_private_dns_a_record.a_rec_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.a_rec_sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.dev_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.sql_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.dev_vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.sql_vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.pep_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.pep_sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.audit_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_data_lake_gen2_filesystem.datalake](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) | resource |
| [azurerm_synapse_firewall_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_firewall_rule) | resource |
| [azurerm_synapse_linked_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_linked_service) | resource |
| [azurerm_synapse_managed_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_managed_private_endpoint) | resource |
| [azurerm_synapse_spark_pool.pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_spark_pool) | resource |
| [azurerm_synapse_sql_pool.sql_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_sql_pool) | resource |
| [azurerm_synapse_workspace.synapse](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace) | resource |
| [azurerm_synapse_workspace_extended_auditing_policy.synapse_auditing_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_extended_auditing_policy) | resource |
| [azurerm_synapse_workspace_key.workspace_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_key) | resource |
| [azurerm_synapse_workspace_security_alert_policy.synapse_workspace_security_alert_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_security_alert_policy) | resource |
| [azurerm_synapse_workspace_vulnerability_assessment.synapse_workspace_vulnerability_assessment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_vulnerability_assessment) | resource |
| [random_password.synapse_sql_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_offset.pike](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) | resource |
| [azurenoopsutils_resource_name.rg](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.synapse](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_private_endpoint_connection.pip_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_endpoint_connection) | data source |
| [azurerm_private_endpoint_connection.pip_sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_endpoint_connection) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.audit_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account.auditing_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_storage_container.vulnerability_assessment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_container) | data source |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_admins"></a> [aad\_admins](#input\_aad\_admins) | The AAD admins of this workspace. Conflicts with customer\_managed\_key | <pre>list(object({<br>    login     = string<br>    object_id = string<br>    tenant_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Map of custom tags. | `map(string)` | `{}` | no |
| <a name="input_allowed_firewall_rules"></a> [allowed\_firewall\_rules](#input\_allowed\_firewall\_rules) | List  of rules allowing certain ips through the firewall. | <pre>list(object({<br>    name : string<br>    start_ip_address : string<br>    end_ip_address : string<br>  }))</pre> | `null` | no |
| <a name="input_audit_retention_in_days"></a> [audit\_retention\_in\_days](#input\_audit\_retention\_in\_days) | Number of days for retention of security policies | `number` | `30` | no |
| <a name="input_auditing_policy_storage_account_id"></a> [auditing\_policy\_storage\_account\_id](#input\_auditing\_policy\_storage\_account\_id) | ID of SQL audit policy storage account | `string` | `null` | no |
| <a name="input_azure_devops_configuration"></a> [azure\_devops\_configuration](#input\_azure\_devops\_configuration) | Configuration for connecting the workspace to a Azure Devops repo. | <pre>object({<br>    account_name    = string<br>    branch_name     = string<br>    last_commit_id  = optional(string)<br>    project_name    = string<br>    repository_name = string<br>    root_folder     = string<br>    tenant_id       = string<br>  })</pre> | `null` | no |
| <a name="input_compute_subnet_id"></a> [compute\_subnet\_id](#input\_compute\_subnet\_id) | Subnet ID used for computes in workspace | `string` | `null` | no |
| <a name="input_create_synapse_resource_group"></a> [create\_synapse\_resource\_group](#input\_create\_synapse\_resource\_group) | Create a resource group for the Synapse Workspace. If set to false, the existing\_resource\_group\_name variable must be set. Default is false. | `bool` | `false` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_synapse_workspace_name"></a> [custom\_synapse\_workspace\_name](#input\_custom\_synapse\_workspace\_name) | The name of the custom Synapse Workspace to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_data_exfiltration_protection_enabled"></a> [data\_exfiltration\_protection\_enabled](#input\_data\_exfiltration\_protection\_enabled) | Is data exfiltration protection enabled in this workspace ? | `bool` | `false` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | Name of the workload's environment | `string` | n/a | yes |
| <a name="input_enable_audit_log_monitoring"></a> [enable\_audit\_log\_monitoring](#input\_enable\_audit\_log\_monitoring) | Enables or disabled audit log monitorng. | `bool` | `true` | no |
| <a name="input_enable_customer_managed_keys"></a> [enable\_customer\_managed\_keys](#input\_enable\_customer\_managed\_keys) | Enable customer managed keys for this workspace. Default is false. | `bool` | `false` | no |
| <a name="input_enable_managed_virtual_network"></a> [enable\_managed\_virtual\_network](#input\_enable\_managed\_virtual\_network) | Is managed virtual network enabled in this workspace? | `bool` | `true` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Manages a Private Endpoint to Azure Container Registry. Default is false. | `bool` | `false` | no |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | (Optional) Enable resource locks, default is false. If true, resource locks will be created for the resource group and the storage account. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| <a name="input_existing_dev_private_dns_zone"></a> [existing\_dev\_private\_dns\_zone](#input\_existing\_dev\_private\_dns\_zone) | Name of the existing synapse dev private DNS zone | `any` | `null` | no |
| <a name="input_existing_private_subnet_name"></a> [existing\_private\_subnet\_name](#input\_existing\_private\_subnet\_name) | Name of the existing subnet for the private endpoint | `any` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_existing_sql_private_dns_zone"></a> [existing\_sql\_private\_dns\_zone](#input\_existing\_sql\_private\_dns\_zone) | Name of the existing synapse sql private DNS zone | `any` | `null` | no |
| <a name="input_existing_virtual_network_name"></a> [existing\_virtual\_network\_name](#input\_existing\_virtual\_network\_name) | Name of the virtual network for the private endpoint | `any` | `null` | no |
| <a name="input_existing_web_private_dns_zone"></a> [existing\_web\_private\_dns\_zone](#input\_existing\_web\_private\_dns\_zone) | Name of the existing synapse web private DNS zone | `any` | `null` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | Configuration for connecting the workspace to a GitHub repo. | <pre>object({<br>    account_name    = string<br>    branch_name     = string<br>    last_commit_id  = optional(string, null)<br>    repository_name = string<br>    root_folder     = optional(string, "/")<br>    git_url         = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account. | `list(string)` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both). | `string` | `"SystemAssigned"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The ID of the key vault to be used for customer managed keys | `string` | `null` | no |
| <a name="input_linked_services"></a> [linked\_services](#input\_linked\_services) | List over linked services. | <pre>list(object({<br>    name : string<br>    type : string<br>    type_properties : map(any)<br>    additional_properties : optional(map(string), null)<br>    annotations : optional(list(string), [])<br>    description : optional(string, "")<br>    integration_runtime = optional(object({<br>      name : optional(string, null)<br>      parameters : optional(map(string), null)<br>    }), null)<br>    parameters : optional(map(string), null)<br>  }))</pre> | `[]` | no |
| <a name="input_linking_allowed_for_aad_tenant_ids"></a> [linking\_allowed\_for\_aad\_tenant\_ids](#input\_linking\_allowed\_for\_aad\_tenant\_ids) | Allowed Aad Tenant Ids For Linking | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which instance will be hosted | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| <a name="input_managed_private_endpoints"></a> [managed\_private\_endpoints](#input\_managed\_private\_endpoints) | List over managed private endpoints. | <pre>list(object({<br>    name : string<br>    target_resource_id : string<br>    subresource_name : string<br>  }))</pre> | `[]` | no |
| <a name="input_managed_resource_group_name"></a> [managed\_resource\_group\_name](#input\_managed\_resource\_group\_name) | Workspace managed resource group name | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | The object ID of the key vault user principal id to be used for customer managed keys | `string` | `null` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Name of the organization | `string` | n/a | yes |
| <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id) | The ID of purview account. | `string` | `null` | no |
| <a name="input_saas_connection"></a> [saas\_connection](#input\_saas\_connection) | Used to configure Public Network Access | `bool` | `false` | no |
| <a name="input_spark_pools"></a> [spark\_pools](#input\_spark\_pools) | A list of Spark pools to create. | <pre>list(object({<br>    name : string<br>    node_size_family : string<br>    node_size : string<br>    node_count : optional(number, null)<br>    auto_pause_delay_in_minutes : optional(number, 5)<br>    auto_scale : optional(object({<br>      max_node_count : number<br>      min_node_count : number<br>    }), null)<br>    cache_size : optional(number, null)<br>    compute_isolation_enabled : optional(bool, false)<br>    dynamic_executor_allocation_enabled : optional(bool, true)<br>    min_executors : optional(number, 1)<br>    max_executors : optional(number, 2)<br>    library_requirement : optional(object({<br>      content : string<br>      filename : string<br>    }), null)<br>    session_level_packages_enabled : optional(bool, false)<br>    spark_config : optional(object({<br>      content : string<br>      filename : string<br>    }), null)<br>    spark_log_folder : optional(string, null)<br>    spark_events_folder : optional(string, null)<br>    spark_version : optional(string, null)<br>    tags : optional(map(string), null)<br>  }))</pre> | `[]` | no |
| <a name="input_sql_aad_admins"></a> [sql\_aad\_admins](#input\_sql\_aad\_admins) | The SQL AAD admins of this workspace | <pre>set(object({<br>    login     = string<br>    object_id = string<br>    tenant_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_sql_administrator_login"></a> [sql\_administrator\_login](#input\_sql\_administrator\_login) | Administrator login of synapse sql database | `string` | n/a | yes |
| <a name="input_sql_administrator_password"></a> [sql\_administrator\_password](#input\_sql\_administrator\_password) | Administrator password of synapse sql database | `string` | n/a | yes |
| <a name="input_sql_defender"></a> [sql\_defender](#input\_sql\_defender) | Alert policy settings for the Synapse workspace. If null, no alert policy will be created. Audit\_container is a blob storage container path to hold the scan results and all Threat Detection audit logs. | <pre>object({<br>    state                        = optional(string, "Enabled")<br>    disabled_alerts              = optional(list(string), [])<br>    email_account_admins_enabled = optional(bool, false)<br>    alert_email_addresses        = optional(list(string), [])<br>    retention_days               = optional(number, 0)<br>    recurring_scans = optional(object({<br>      enabled                           = bool<br>      email_subscription_admins_enabled = bool<br>      emails                            = list(string)<br>    }))<br>    audit_container = optional(object({<br>      name                 = string<br>      storage_account_name = string<br>      resource_group_name  = string<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_sql_identity_control_enabled"></a> [sql\_identity\_control\_enabled](#input\_sql\_identity\_control\_enabled) | Are pipelines (running as workspace's system assigned identity) allowed to access SQL pools? | `bool` | `false` | no |
| <a name="input_sql_pools"></a> [sql\_pools](#input\_sql\_pools) | A list of sql pools to create. | <pre>list(object({<br>    name : string<br>    sku_name : string<br>    create_mode : optional(string, "Default")<br>    collation : optional(string, "SQL_LATIN1_GENERAL_CP1_CI_AS")<br>    data_encrypted : optional(string, true)<br>    recovery_database_id : optional(string, null)<br>    restore : optional(object({<br>      source_database_id : optional(string)<br>      point_in_time : optional(string)<br>    }), null)<br>    geo_backup_policy_enabled : optional(bool, true)<br>    tags : optional(map(string), null)<br>  }))</pre> | `[]` | no |
| <a name="input_storage_data_lake_gen2_id"></a> [storage\_data\_lake\_gen2\_id](#input\_storage\_data\_lake\_gen2\_id) | The ID of the storage account to be used for data lake gen2 | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The tenant ID of the key vault to be used for customer managed keys | `string` | `null` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload\_name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connectivity_endpoints"></a> [connectivity\_endpoints](#output\_connectivity\_endpoints) | A list of connectivity endpoints for this Synapse Workspace. |
| <a name="output_id"></a> [id](#output\_id) | Synapse ID |
| <a name="output_name"></a> [name](#output\_name) | Synapse name |
<!-- END_TF_DOCS -->