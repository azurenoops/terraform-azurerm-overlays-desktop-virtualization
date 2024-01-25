# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  resource_group_id = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_client_config.current.subscription_id, local.resource_group_name)
}
