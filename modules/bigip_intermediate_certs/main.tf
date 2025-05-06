# Module uploads CA intermediate certs to BIG-IP

locals {
  ca_certs = {
    for name in var.certificate_names : name => file("${var.cert_files_path}/${name}.crt")
  }
}

resource "bigip_ssl_certificate" "certs" {
  for_each = local.ca_certs

  name      = each.key
  content   = each.value
  partition = "Common"
}
