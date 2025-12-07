terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.83.0"
    }
    ct = {
      source = "poseidon/ct"
      version = "0.13.0"
    }
  }

  backend "s3" {
    bucket       = "rize-tfstate"
    key          = "pve-thinkcentre/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = true

  ssh {
    agent = true
  }
}