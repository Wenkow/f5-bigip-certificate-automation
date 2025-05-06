terraform {
  required_version = "~> 1.8"

  required_providers {
    bigip = {
      source = "F5Networks/bigip"
    }
  }
}