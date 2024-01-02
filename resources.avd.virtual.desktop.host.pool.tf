# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##############################################
# AZURE Host Pool
##############################################

resource "azurerm_virtual_desktop_host_pool" "pool" {
  name                = local.host_pool_name
  friendly_name       = "${var.deploy_environment}${var.workload_name}pool"
  resource_group_name = local.resource_group_name
  location            = local.location

  type                     = var.host_pool_type
  load_balancer_type       = var.host_pool_load_balancer_type
  validate_environment     = var.host_pool_validate_environment
  start_vm_on_connect      = var.start_vm_on_connect
  maximum_sessions_allowed = var.host_pool_max_sessions_allowed

  dynamic "scheduled_agent_updates" {
    for_each = var.scheduled_agent_updates == null ? [] : ["enabled"]
    content {
      enabled = each.value.enabled
      schedule {
        day_of_week = each.value.day_of_week
        hour_of_day = each.value.hour_of_day
      }
    }
  }

  tags = merge(local.default_tags, var.add_tags)

}

##############################################
# AZURE Host Pool Registration Info
##############################################

resource "azurerm_virtual_desktop_host_pool_registration_info" "example" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.pool.id
  expiration_date = var.expiration_date
}