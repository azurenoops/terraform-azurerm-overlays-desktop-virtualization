# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##############################################
# AZURE VIRTUAL DESKTOP Application Group
##############################################

resource "azurerm_virtual_desktop_application_group" "app_group" {
  name     = local.avd_app_group_name
  location = local.location

  resource_group_name = local.resource_group_name

  host_pool_id = azurerm_virtual_desktop_host_pool.host_pool.id

  friendly_name                = coalesce(var.avd_application_group_config.friendly_name, local.avd_app_group_name)
  default_desktop_display_name = var.avd_application_group_config.type == "Desktop" ? var.avd_application_group_config.default_desktop_display_name : null
  description                  = var.avd_application_group_config.description

  type = var.avd_application_group_config.type

  tags = merge(local.default_tags, var.avd_application_group_config.extra_tags, var.add_tags)
}

##################################################
# AZURE Workspace Application Group Association
##################################################

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace_app_group_association" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.app_group.id
}
