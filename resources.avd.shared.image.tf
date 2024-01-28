# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##################################################
# Share Image Gallery
##################################################

/* resource "azurerm_shared_image" "image" {
  for_each            = var.avd_shared_image != null ? toset(var.avd_shared_image) : {}
  name                = each.value.sig_image_name
  gallery_name        = each.value.shared_image_gallery_name
  resource_group_name = local.resource_group_name
  location            = local.location
  os_type             = each.value.os_type

  identifier {
    publisher = var.avd_shared_image_gallery.identifier.publisher
    offer     = var.avd_shared_image_gallery.identifier.offer
    sku       = var.avd_shared_image_gallery.identifier.sku
  }
}
 */