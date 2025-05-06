output "uploaded_intermediate_certs" {
  value = [for k in keys(local.ca_certs) : k]
}
