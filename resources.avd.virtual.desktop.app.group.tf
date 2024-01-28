# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##############################################
# AZURE VIRTUAL DESKTOP Application Group
##############################################

resource "azurerm_virtual_desktop_application_group" "app_group" {
  for_each = toset(local.aad_group_list)

  name     = "${local.avd_app_group_name}${format("%02d", "${index(local.aad_group_list, each.value) + 1}")}"
  location = local.location  

  resource_group_name = local.resource_group_name
  host_pool_id = azurerm_virtual_desktop_host_pool.pool.id

  friendly_name       = "${each.value} application group"
  description         = "${each.value} application group - created with Azure NoOps."
  type = var.avd_application_group_config.type == "Application" ? "RemoteApp" : "Desktop"

  tags = merge(local.default_tags, var.avd_application_group_config.add_tags, var.add_tags)
}

##################################################
# AZURE Workspace Application Group Association
##################################################

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace_app_group_association" {
  for_each             = toset(local.aad_group_list)
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.app_group[each.value].id
}

##############################################################
# AZURE VIRTUAL DESKTOP AAD group role and scope assignment
##############################################################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "rbac" {
  for_each           = toset(local.aad_group_list)
  scope              = azurerm_virtual_desktop_application_group.app_group[each.value].id
  role_definition_id = data.azurerm_role_definition.avduser_role.id
  principal_id       = data.azuread_group.aad_group[each.value].id
}