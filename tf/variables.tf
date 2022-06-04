variable "project" {
  default = "hillel-project-1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "region" {
  default = "us-central1"
}

variable "credentials" {
  description = "../../gcp_keys/hillel-project-1-e39e275fb220.json"
}

variable "subnet_cidr" {
  default = "10.10.10.0/24"
}

variable "user" {
  description = "ssh connection user"
}

variable "ssh_pub_key" {
  description = "path to your public ssh key"
}

variable "network_name" {
  default = "ansible"
}

//+
variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "f1-micro"
}

variable "instance_image" {
  description = "Instance image"
  type        = string
  default     = "debian-10-buster-v20220317"
}

variable "subnet_name" {
  description = "VPC Subnet name"
  type        = string
  default     = "subnet-01"
}