resource "openstack_compute_keypair_v2" "vm" {
  name = var.keypair_name
}

resource "openstack_compute_instance_v2" "vm" {
  count           = var.instance_count
  name            = "${var.instance_name}[count.index]"
  image_id        = data.openstack_images_image_v2.vm.id
  flavor_id       = data.openstack_compute_flavor_v2.vm.id
  key_pair        = openstack_compute_keypair_v2.vm.name
  security_groups = var.security_groups

  network {
    name = var.network_name
  }
}

resource "local_file" "priv_key" {
  sensitive_content = openstack_compute_keypair_v2.vm.private_key
  filename          = "/home/terraform/.ssh/priv_key"
  file_permission   = "0600"
}

resource "null_resource" "local" {

  triggers = {
    time = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "${path.module}/files/scripts_bolt.sh"
  }
}

resource "null_resource" "remote" {
  depends_on = [null_resource.local, openstack_compute_instance_v2.vm]
  count      = length(openstack_compute_instance_v2.vm.*.name)

  triggers = {
    time = "${timestamp()}"
  }

  provisioner "puppet" {
    server      = "puppetmaster.lab.deploy.ovh.net"
    server_user = "centos"
    use_sudo    = true
    os_type     = "linux"
    environment = "production"
    autosign    = false
    open_source = true
  }

  connection {
    type        = "ssh"
    host        = openstack_compute_instance_v2.vm[count.index].access_ip_v4
    user        = "centos"
    private_key = openstack_compute_keypair_v2.vm[count.index].private_key
  }
}