# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# AZURE VIRTUAL DESKTOP Workspace - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "azurerm_virtual_desktop_workspace_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.avd_workspace_name}-${var.lock_level}-lock"
  scope      = azurerm_virtual_desktop_workspace.workspace.id
  lock_level = var.lock_level
  notes      = "Virtual Network '${local.avd_workspace_name}' is locked with '${var.lock_level}' level."
}

#------------------------------------------------------------
# AZURE VIRTUAL DESKTOP Host Pool Locks
#------------------------------------------------------------
resource "azurerm_management_lock" "azurerm_virtual_desktop_host_pool_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.avd_host_pool_name}-${var.lock_level}-lock"
  scope      = azurerm_virtual_desktop_host_pool.pool.id
  lock_level = var.lock_level
  notes      = "Virtual Network '${local.avd_host_pool_name}' is locked with '${var.lock_level}' level."
}

#------------------------------------------------------------
# AZURE VIRTUAL DESKTOP Workspace - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "azurerm_virtual_desktop_app_group_level_lock" {
  for_each   = toset(var.enable_resource_locks ? local.aad_group_list : null)
  name       = "${local.avd_app_group_name}-${var.lock_level}-lock${format("%02d", "${index(local.aad_group_list, each.value) + 1}")}"
  scope      = azurerm_virtual_desktop_application_group.app_group[each.value].id
  lock_level = var.lock_level
  notes      = "Virtual Network '${local.avd_app_group_name}${format("%02d", "${index(local.aad_group_list, each.value) + 1}")}' is locked with '${var.lock_level}' level."
}
