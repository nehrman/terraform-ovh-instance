variable "image_name" {
  description = "OpenStack Image Name"
  default     = "Centos 7"
}

variable "flavor_vcpus" {
  description = "OpenStack Flavor vCPUs"
  default     = "2"
}

variable "flavor_min_vram" {
  description = "OpenStack Flavor minimum vRAM"
  default     = "3096"
}

variable "instance_name" {
  description = "VM Instance Name"
}

variable "network_name" {
  description = "Openstack Network Name"
  default     = "Ext-Net"
}

variable "keypair_name" {
  description = "Openstack KeyPair Name"
  default     = "demo"
}

variable "instance_count" {
  description = "Instance Count"
  default     = "1"
}

variable "security_groups" {
  description = "Openstack Security Groups List"
  type        = list
  default     = ["default"]
}

