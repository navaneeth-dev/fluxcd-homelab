terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0-alpha.0"
    }
  }

  backend "s3" {
    bucket       = "rize-tfstate"
    key          = "fluxcd-homelab/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

provider "talos" {}
