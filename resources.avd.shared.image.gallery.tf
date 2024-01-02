
##################################################
# Share Image Gallery
##################################################

resource "azurerm_shared_image_gallery" "img_gallery" {
  name                = "${var.environment}-${var.workload_name}-image-gallery"
  resource_group_name = local.resource_group_name
  location            = local.location
  description         = "Shared images gallery for storing the images which are to be used across the region"
  tags                = merge(local.default_tags, var.add_tags)
}

resource "azurerm_shared_image" "image" {
  name                = var.sig_image_name
  gallery_name        = azurerm_shared_image_gallery.img_gallery.name
  resource_group_name = local.resource_group_name
  location            = local.location
  os_type             = var.os_type

  identifier {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
  }

}
