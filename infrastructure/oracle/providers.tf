terraform {
  backend "oci" {
    bucket              = "terraform-state"
    namespace           = "axshzxuad4ng"
    config_file_profile = "AKASH"
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "7.14.0"
    }
  }
}

provider "oci" {
  config_file_profile = "AKASH"
}
