variable "desktop_ami" {
  type = string
  default = "ami-0557a15b87f6559cf"
}

variable "onion_ami" {
type = string
default = "ami-09cd747c78a9add63"
}

variable "avail_zone" {
  type = string
  default = "us-east-1a"
}

variable "desktop_type" {
  type = string
  default = "c5a.large"
}

variable "onion_type" {
  type = string
  default = "c5a.large"
}

variable "vpc_ep_svc_name" {
  type = string
  default = "com.amazonaws.us-east-1.s3"
}

variable "cloud_config_onion" {
  default = "cloud-config-onion.sh"
}

variable "cloud_config_desktop" {
  default = "cloud-config-desktop.sh"
}

variable "config-desktop" {
  default = "config-desktop.sh"
}

variable "config-onion" {
  default = "config-onion.sh"
}

variable "config-netplan" {
  default = "50-cloud-init.yaml.patch"
}



