# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##############################################
# AZURE VIRTUAL DESKTOP Workspace
##############################################

resource "azurerm_virtual_desktop_workspace" "workspace" {
  name     = local.avd_workspace_name
  location = local.location

  resource_group_name = local.resource_group_name

  friendly_name = coalesce(var.avd_workspace_config.friendly_name, "Virtual ${var.avd_host_pool_config.type != "Application" ? "Applications" : "Desktop"} Workspace")
  description   = coalesce(var.avd_workspace_config.description, "${title(var.org_name)} Azure Virtual Desktop Workspace created by Azure NoOps.")

  public_network_access_enabled = var.avd_workspace_config.public_network_access_enabled

  tags = merge(local.default_tags, var.avd_workspace_config.add_tags, var.add_tags)

  lifecycle {
    ignore_changes = [
      description
    ]
  }
}
