terraform {
  backend "oci" {
    bucket            = "terraform-state"
    namespace         = "axshzxuad4ng"
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

// Oracle
variable "user_ocid" {
}

variable "fingerprint" {
}

variable "tenancy_ocid" {
}

variable "region" {
}

variable "private_key_path" {
  default = ""
}

variable "compartment_ocid" {
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}
