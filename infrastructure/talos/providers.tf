terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0-alpha.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.38.0"
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

provider "kubernetes" {
  config_path    = "../../kubeconfig"
  config_context = "admin@hoopa"
}