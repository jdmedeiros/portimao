terraform {
  required_version = ">= 1.3.9"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.56.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  #access_key = "xxxx"
  #secret_key = "xxxx"
  #token = "xxxx"

  profile = "vocareum"
}

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.1.1"
}

provider "cloudinit" {
}

data "template_cloudinit_config" "config-desktop" {
  gzip = false
  base64_encode = false

  part {
    filename = var.cloud_config_desktop
    content_type = "text/x-shellscript"
    content = file(var.cloud_config_desktop)
  }

  part {
    filename = var.config-desktop
    content_type = "text/x-shellscript"
    content = file(var.config-desktop)
  }

  part {
    filename = var.config-onion
    content_type = "text/x-shellscript"
    content = file(var.config-onion)
  }

  part {
    filename = var.config-netplan
    content_type = "text/x-shellscript"
    content = file(var.config-netplan)
  }
}

data "template_cloudinit_config" "config-onion" {
  gzip = false
  base64_encode = false

  part {
    filename = var.cloud_config_onion
    content_type = "text/x-shellscript"
    content = file(var.cloud_config_onion)
  }

  part {
    filename = var.config-onion
    content_type = "text/x-shellscript"
    content = file(var.config-onion)
  }

  part {
    filename = var.config-netplan
    content_type = "text/x-shellscript"
    content = file(var.config-netplan)
  }
}
