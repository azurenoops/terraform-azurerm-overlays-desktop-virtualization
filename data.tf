# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_client_config" "current" {}

# Required permissions to access an Azure VM. 
data "azurerm_role_definition" "avduser_role" {
  name = "Desktop Virtualization User"
}

# Each AAD group needed for permissioning. 
data "azuread_group" "aad_group" {
  for_each         = toset(local.aad_group_list)
  display_name     = each.value
  security_enabled = true
}

data "azuread_service_principal" "avd_service_principal" {
  count = (
    var.scaling_plan_config.enabled && var.scaling_plan_config.role_assignment.enabled && var.scaling_plan_config.role_assignment.principal_id == null
  ) ? 1 : 0

  client_id = local.avd_service_principal_client_id
}