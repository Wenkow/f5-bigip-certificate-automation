module "bigip_intermediate_certs" {
  source          = "./modules/bigip_intermediate_certs"
  cert_files_path = "${path.module}/CA_certs"
  certificate_names = [
    "LetsEncrypt_E5",
    "LetsEncrypt_E6",
    "LetsEncrypt_E7",
    "LetsEncrypt_E8",
    "LetsEncrypt_E9",
    "LetsEncrypt_R10",
    "LetsEncrypt_R11",
    "LetsEncrypt_R12",
    "LetsEncrypt_R13",
    "LetsEncrypt_R14"
  ]
}


module "dns_challenge" {
  depends_on = [module.bigip_intermediate_certs]
  source     = "./modules/acme_dns"
  for_each   = local.dns_challenge_certs

  name                      = each.key
  cn                        = each.value["cn"]
  san                       = each.value["san"]
  partition                 = try(each.value["partition"], null)
  parent_ssl_profile        = try(each.value["parent_ssl_profile"], null)
  global_parent_ssl_profile = var.global_parent_ssl_profile
  acme_account              = acme_registration.reg.account_key_pem
  F5XC_API_TOKEN            = var.F5XC_API_TOKEN
  F5XC_TENANT_NAME          = var.F5XC_TENANT_NAME
  F5XC_GROUP_NAME           = var.F5XC_GROUP_NAME
}
