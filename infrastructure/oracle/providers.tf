terraform {
  backend "oci" {
    bucket              = "terraform-state"
    namespace           = "axshzxuad4ng"
    config_file_profile = "AKASH"
  }

  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.8.1"
    }

    oci = {
      source  = "oracle/oci"
      version = "7.14.0"
    }
  }
}

provider "talos" {
}

provider "oci" {
  config_file_profile = "AKASH"
}
