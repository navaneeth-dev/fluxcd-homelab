terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.83.0"
    }
  }

  backend "s3" {
    bucket       = "rize-tfstate"
    key          = "homelab-proxmox/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

provider "proxmox" {
  endpoint = var.endpoint
  insecure = true

  ssh {
    agent = true
  }
}