resource "openstack_compute_keypair_v2" "vm" {
  name = var.keypair_name
}

resource "openstack_compute_instance_v2" "vm" {
  name            = var.instance_name
  image_id        = data.openstack_images_image_v2.vm.id
  flavor_id       = data.openstack_compute_flavor_v2.vm.id
  key_pair        = openstack_compute_keypair_v2.vm.name
  security_groups = var.security_groups

  network {
    name = var.network_name
  }
}

resource "null_resource" "vm" {

  provisioner "local-exec" {
    command = "echo -e openstack_compute_keypair_v2.vm.private_key > $HOME/.ssh/priv_key && chmod 0400 $HOME/.ssh/priv_key"
  }

  provisioner "file" {
    source      = file("${path.module}/files/scripts_bolt.sh")
    destination = "$HOME/scripts_bolt.sh"
  }


  /*     provisioner "puppet" "web" {
        server = "puppetmaster.lab.deploy.ovh.net"
        server_user = "root"
        os_type = "linux"
        environment = "production"
        autosign = true
        open_source = true
    } */
}