data "openstack_images_image_v2" "vm" {
  name        = var.image_name
  most_recent = true
}

data "openstack_compute_flavor_v2" "vm" {
  vcpus   = var.flavor_vcpus
  min_ram = var.flavor_min_vram
}