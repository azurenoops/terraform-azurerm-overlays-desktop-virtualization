
##################################################
# Share Image Gallery
##################################################

resource "azurerm_shared_image_gallery" "img_gallery" {
  name                = "${var.org_name}-${module.mod_azure_region_lookup.location_short}-${var.deploy_environment}-${var.workload_name}-sig"
  resource_group_name = local.resource_group_name
  location            = local.location
  description         = "Shared images gallery for storing the images which are to be used across the region"
  tags                = merge(local.default_tags, var.add_tags)
}

resource "azurerm_shared_image" "image" {
  name                = var.avd_shared_image_gallery.sig_image_name
  gallery_name        = azurerm_shared_image_gallery.img_gallery.name
  resource_group_name = local.resource_group_name
  location            = local.location
  os_type             = var.avd_shared_image_gallery.os_type

  identifier {
    publisher = var.avd_shared_image_gallery.identifier.publisher
    offer     = var.avd_shared_image_gallery.identifier.offer
    sku       = var.avd_shared_image_gallery.identifier.sku
  }
}
