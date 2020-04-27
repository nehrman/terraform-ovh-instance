resource "openstack_compute_keypair_v2" "vm" {
  name = var.keypair_name
}

resource "openstack_compute_instance_v2" "vm" {
  name            = var.instance_name
  image_id        = data.openstack_images_image_v2.vm.id
  flavor_id       = data.openstack_compute_flavor_v2.vm.id
  key_pair         = openstack_compute_keypair_v2.vm.name
  security_groups = var.security_groups

  network {
    name = var.network_name
  }
}