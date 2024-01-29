# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##################################################
# AZURE VIRTUAL DESKTOP Application
##################################################

resource "azurerm_virtual_desktop_application" "application" {
  for_each                     = local.applications
  name                         = replace(each.value["app_name"], " ", "")
  friendly_name                = each.value["friendly_name"] != null ? each.value["friendly_name"] : each.value["app_name"]
  description                  = "${each.value["app_name"]} application - created with Azure NoOps."
  application_group_id         = azurerm_virtual_desktop_application_group.app_group[each.value["aad_group"]].id
  path                         = each.value["path"]
  command_line_argument_policy = each.value["command_line_arguments"] != null ? "DoNotAllow" : "Require"
  command_line_arguments       = each.value["command_line_arguments"]
  show_in_portal               = each.value["show_in_portal"]
  icon_path                    = each.value["icon_path"]
  icon_index                   = each.value["icon_index"]
  lifecycle {
    ignore_changes = [
      description
    ]
  }
}
