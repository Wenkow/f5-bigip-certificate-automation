variable "cert_files_path" {
  description = "Path to directory containing .crt intermediate CA files"
  type        = string
}
variable "certificate_names" {
  description = "List of certificate file base names (no extension)"
  type        = list(string)
}