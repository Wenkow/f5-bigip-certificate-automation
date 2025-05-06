variable "acme_account" {
  description = "LE account key"
  type        = string
}
variable "name" {
  description = "certificate object name (used for naming in BIG-IP)"
  type        = string
}
variable "cn" {
  description = "Certificate Common Name / CN attribute "
  type        = string
}
variable "san" {
  description = "Certificate Subject Alternative Name / SAN field"
  type        = set(string)
}
variable "partition" {
  description = "BIG-IP partition to store certificate in - defaults to Common"
  type        = string
  default     = null
}
variable "global_parent_ssl_profile" {
  description = "Parent client SSL profile from which newly created SSL profiles will be derived (in Common partition)"
  type        = string
}
variable "parent_ssl_profile" {
  description = "Parent client SSL profile from which newly created SSL profiles will be derived (in Common partition). This one overrides global."
  type        = string
  default     = null
}
variable "F5XC_API_TOKEN" {
  description = "F5 Distributed Cloud API Token"
  type        = string
}
variable "F5XC_TENANT_NAME" {
  description = "F5 Distributed Cloud tenant shortname "
  type        = string
}
variable "F5XC_GROUP_NAME" {
  description = "F5 Distributed Cloud challenge records RRSet name"
  type        = string
}