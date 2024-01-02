# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##############################################
# AZURE VIRTUAL DESKTOP Workspace
##############################################

resource "azurerm_virtual_desktop_workspace" "ws" {
  name                = local.workspace_name
  resource_group_name = local.resource_group_name
  location            = local.location
  friendly_name       = var.workload_name
  description         = var.workspace_description
  tags                = merge(local.default_tags, var.add_tags)
}

resource "azurerm_virtual_desktop_application_group" "avd" {
  name                = local.avd_app_group_name
  resource_group_name = local.resource_group_name
  location            = local.location
  host_pool_id        = azurerm_virtual_desktop_host_pool.pool.id
  type                = var.desktop_app_group_type
  friendly_name       = var.workload_name
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "ws_ass" {
  workspace_id         = azurerm_virtual_desktop_workspace.ws.id
  application_group_id = azurerm_virtual_desktop_application_group.avd.id
}
