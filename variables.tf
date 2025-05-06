variable "email_address" {
  description = "Contact email address provided to Let's encrypt"
  type        = string
}
variable "F5XC_API_TOKEN" {
  description = "F5 Distributed Cloud API Token"
  type        = string
  sensitive   = true
}
variable "F5XC_TENANT_NAME" {
  description = "F5 Distributed Cloud tenant shortname "
  type        = string
  sensitive   = false
}
variable "F5XC_GROUP_NAME" {
  description = "F5 Distributed Cloud challenge records RRSet name"
  type        = string
}
variable "BIGIP_HOST" {
  description = "BIGIP hostname or IP (standalone or cluster)"
  type        = string
}
variable "BIGIP_PORT" {
  description = "BIGIP management port (standalone or cluster)"
  type        = string
  default     = "443"
}
variable "BIGIP_USERNAME" {
  description = "BIGIP logon username"
  type        = string
}
variable "BIGIP_PASSWORD" {
  description = "BIGIP logon password"
  type        = string
}
variable "global_parent_ssl_profile" {
  description = "Parent client SSL profile from which newly created SSL profiles will be derived (in Common partition)"
  type        = string
  default     = "clientssl"
}