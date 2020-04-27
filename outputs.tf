output "ip_address" {
  value = openstack_compute_instance_v2.vm.access_ip_v4
}

output "private_key" {
  value = openstack_compute_keypair_v2.vm.private_key
}