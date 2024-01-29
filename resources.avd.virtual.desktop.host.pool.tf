# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##############################################
# AZURE VIRTUAL DESKTOP Host Pool
##############################################

resource "azurerm_virtual_desktop_host_pool" "pool" {
  name                = local.avd_host_pool_name
  friendly_name       = coalesce(var.avd_host_pool_config.friendly_name, local.avd_host_pool_name)
  description         = var.avd_host_pool_config.description
  resource_group_name = local.resource_group_name
  location            = local.location

  validate_environment  = var.avd_host_pool_config.validate_environment
  custom_rdp_properties = var.avd_host_pool_config.custom_rdp_properties

  type                             = var.avd_host_pool_config.type == "Desktop" ? "Personal" : "Pooled"
  load_balancer_type               = var.avd_host_pool_config.type == "Personal" ? "Persistent" : var.avd_host_pool_config.load_balancer_type
  personal_desktop_assignment_type = var.avd_host_pool_config.type == "Personal" ? var.avd_host_pool_config.personal_desktop_assignment_type : null
  maximum_sessions_allowed         = var.avd_host_pool_config.type == "Pooled" ? var.avd_host_pool_config.maximum_sessions_allowed : null
  preferred_app_group_type         = coalesce(var.avd_host_pool_config.preferred_app_group_type, var.avd_application_group_config.type == "Desktop" ? "Desktop" : "RailApplications")
  start_vm_on_connect              = var.avd_host_pool_config.type != "Application" ? true : false

  scheduled_agent_updates {
    enabled                   = var.avd_host_pool_config.scheduled_agent_updates.enabled
    timezone                  = var.avd_host_pool_config.scheduled_agent_updates.timezone
    use_session_host_timezone = var.avd_host_pool_config.scheduled_agent_updates.use_session_host_timezone

    dynamic "schedule" {
      for_each = var.avd_host_pool_config.scheduled_agent_updates.enabled ? var.avd_host_pool_config.scheduled_agent_updates.schedules : []
      content {
        day_of_week = schedule.value.day_of_week
        hour_of_day = schedule.value.hour_of_day
      }
    }
  }

  tags = merge(local.default_tags, var.add_tags)

  lifecycle {
    ignore_changes = [
      description,
      custom_rdp_properties
    ]
  }
}

# `terraform/tfwrapper taint module.avd.time_rotating.time` to force recreation
resource "time_rotating" "time" {
  rotation_hours = var.avd_host_pool_config.host_registration_expires_in_in_hours

  lifecycle {
    ignore_changes = all
  }
}

##############################################
# AZURE Host Pool Registration Info
##############################################

resource "azurerm_virtual_desktop_host_pool_registration_info" "host_pool_registration_info" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.pool.id
  expiration_date = time_rotating.time.rotation_rfc3339
}
