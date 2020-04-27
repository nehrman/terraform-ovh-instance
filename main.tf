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

  triggers = {
      time = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT 
        echo -e ${openstack_compute_keypair_v2.vm.private_key} > ~/.ssh/priv_key 
        chmod 0400 ~/.ssh/priv_key 
        cat ~/.ssh/priv_key
        EOT
  }

  provisioner "local-exec" {
    command     = "${path.module}/files/scripts_bolt.sh"
  }


  provisioner "puppet" {
        server = "puppetmaster.lab.deploy.ovh.net"
        server_user = "centos"
        os_type = "linux"
        environment = "production"
        autosign = true
        open_source = true

        connection {
            type = "ssh"
            host = openstack_compute_instance_v2.vm.access_ip_v4
            user = "centos"
            private_key = "~/.ssh/priv_key"
        }
    } 
}