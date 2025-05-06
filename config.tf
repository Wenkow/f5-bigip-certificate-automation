provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}
resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email_address
}
provider "bigip" {
  address                = var.BIGIP_HOST
  username               = var.BIGIP_USERNAME
  password               = var.BIGIP_PASSWORD
  port                   = var.BIGIP_PORT
  validate_certs_disable = true
  token_timeout          = 3600
}