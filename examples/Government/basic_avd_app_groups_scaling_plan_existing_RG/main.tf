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
  existing_resource_group_name = azurerm_resource_group.avd-rg.name
  location                     = var.location
  deploy_environment           = var.deploy_environment
  environment                  = var.environment
  org_name                     = var.org_name
  workload_name                = var.workload_name 

  # AVD Workspace details
  avd_workspace_config = {
    public_network_access_enabled = false
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
  avd_application_group_config =  {  
    RemoteApp = {
      type = "RemoteApp"
      description = "My RemoteApp"
    }
  }

  scaling_plan_config = {
    enabled = true

    # role_assignment = {
    #   # `false` if you do not have permission to create the Role and the Role Assignment, but this must be done somehow
    #   enabled = false
    #
    #   # In case you do not have permsision to retrieve the object ID of the AVD Service Principal
    #   principal_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeeee"
    # }

    schedules = [{
      name                 = "weekdays"
      days_of_week         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      peak_start_time      = "09:00"
      off_peak_start_time  = "22:00"
      ramp_up_start_time   = "08:00"
      ramp_down_start_time = "19:00"
    }]
  }

  # Adding additional TAG's to your Azure resources
  add_tags = {
    Example = "basic_avd_app_groups_scaling_plan_using_existing_RG"
  }
}
