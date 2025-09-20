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
  host = var.cluster_endpoint

  client_certificate     = base64decode(talos_machine_secrets.this.client_configuration.client_certificate)
  client_key             = base64decode(talos_machine_secrets.this.client_configuration.client_key)
  cluster_ca_certificate = base64decode(talos_machine_secrets.this.client_configuration.ca_certificate)

  # config_context = "admin@hoopa"
}