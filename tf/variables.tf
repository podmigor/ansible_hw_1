variable "project" {
  default = "ahre-rnd"
}

variable "zone" {
  default = "europe-west2-a"
}

variable "region" {
  default = "europe-west2"
}

variable "credentials" {
}

variable "subnet_cidr" {
  default = "10.10.10.0/24"
}

variable "user" {
  default = "ahre"
}

variable "ssh_pub_key" {
}

variable "network_name" {
  default = "ansible"
}