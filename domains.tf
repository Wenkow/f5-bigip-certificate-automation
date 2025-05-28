locals {
  domains             = yamldecode(file("${path.module}/domains.yml"))
  dns_challenge_certs = coalesce(local.domains.dns_challenge_certs, {})
}