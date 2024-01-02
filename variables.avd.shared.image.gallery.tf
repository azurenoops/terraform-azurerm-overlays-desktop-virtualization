
### Share Image Gallery ###
variable "sig_image_name" {
  type        = string
  description = "Image definition name"
}

variable "os_type" {
    type = string
    description = "Type of OS"
}

variable "publisher" {
    type = string
    description = "Name of the OS publisher"
}

variable "offer" {
    type = string
    description = "The Offer Name for the Image"
}

variable "sku" {
    type = string
    description = "The Name of the SKU for the Image."
}