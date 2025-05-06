terraform {
  required_version = "~> 1.8"

  required_providers {
    acme = {
      source = "vancluever/acme"
    }
    utilities = {
      source = "craigsloggett/utility-functions"
    }
    bigip = {
      source = "F5Networks/bigip"
    }
  }
}