terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.64"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    oci = {
      source  = "oracle/oci"
      version = ">= 4.69.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.15.0"
    }
  }
}