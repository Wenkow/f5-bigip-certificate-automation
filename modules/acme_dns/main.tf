resource "acme_certificate" "certificate" {

  account_key_pem = var.acme_account
  common_name     = var.cn
  #  recursive_nameservers     = ["8.8.8.8:53"]
  subject_alternative_names    = var.san
  disable_complete_propagation = true
  pre_check_delay              = 30

  dns_challenge {
    provider = "f5xc"
    config = {
      F5XC_API_TOKEN   = var.F5XC_API_TOKEN
      F5XC_TENANT_NAME = var.F5XC_TENANT_NAME
      F5XC_GROUP_NAME  = var.F5XC_GROUP_NAME
      F5XC_TTL         = 180
    }
  }
}

data "tls_certificate" "issuer" {
  depends_on = [
    acme_certificate.certificate
  ]
  content = acme_certificate.certificate.issuer_pem
}

resource "bigip_ssl_key_cert" "key_cert" {
  depends_on = [
    acme_certificate.certificate
  ]


  partition    = var.partition != null ? var.partition : "Common"
  key_name     = "${var.name}_LE.key"
  key_content  = acme_certificate.certificate.private_key_pem
  cert_name    = "${var.name}_LE.pem"
  cert_content = acme_certificate.certificate.certificate_pem
  #  cert_monitoring_type = "ocsp"
  #  issuer_cert = "/Common/${regex("[ER][0-9]*", data.tls_certificate.issuer.certificates[0].subject)}"
  #  cert_ocsp = "LetsEncrypt_${regex("[ER][0-9]*", data.tls_certificate.issuer.certificates[0].subject)}"
}

resource "bigip_ltm_profile_client_ssl" "Client_SSL_Profile" {
  depends_on = [
    bigip_ssl_key_cert.key_cert
  ]

  partition     = var.partition != null ? var.partition : "Common"
  name          = "/${var.partition != null ? var.partition : "Common"}/SSL_Client_${var.name}_LE"
  defaults_from = "/Common/${var.parent_ssl_profile != null ? var.parent_ssl_profile : var.global_parent_ssl_profile}"
  cert          = bigip_ssl_key_cert.key_cert.cert_full_path
  key           = bigip_ssl_key_cert.key_cert.key_full_path
  chain         = "/Common/LetsEncrypt_${regex("[ER][0-9]*", data.tls_certificate.issuer.certificates[0].subject)}"
}