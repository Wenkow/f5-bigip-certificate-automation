locals {
  dns_challenge_certs = {
    "www.xc.f5playground.xyz" = {
      cn  = "acme1.xc.f5playground.xyz"
      san = ["acme1.xc.f5playground.xyz"]
    }
    "wildcard.xc.f5playground.xyz" = {
      cn  = "*.xc.f5playground.xyz"
      san = ["*.xc.f5playground.xyz"]
    }
    "main-5.xc.f5playground.xyz" = {
      cn                 = "main-5.xc.f5playground.xyz"
      san                = ["main-5.xc.f5playground.xyz"]
      parent_ssl_profile = "custom-clientssl"
    }
  }
}
