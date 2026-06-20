#---------------------- Default Tags ---------------------#
 
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Managed_By             = "Terraform"
    Project                = ""
    ARB                    = ""
    Centro_Custo           = ""
    Owner                  = ""
    Domain                 = ""
    Sub_Domain             = ""
    Acronym                = ""
 
  }
}
 
#-------------------- AWS Environment -------------------#
 
variable "environment" {
  description = "The environment for resource deployment (e.g., 'dev', 'hmg', 'prod')."
  type        = string
}
 
#----------------------- S3 Bucket ----------------------#
 
variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}
 
variable "versioning_enabled" {
  description = "Habilitar versionamento do bucket"
  type        = bool
}
 
variable "mfa_delete_enabled" {
  description = "Exigir MFA para deletar versões"
  type        = bool
}
 
variable "encryption_type" {
  description = "Tipo de encriptação (AES256 ou aws:kms)"
  type        = string
}
 
variable "kms_key_id" {
  description = "KMS key ID para encriptação (se encryption_type for aws:kms)"
  type        = string
}
 
variable "block_public_acls" {
  description = "Bloquear ACLs públicas"
  type        = bool
}
 
variable "block_public_policy" {
  description = "Bloquear políticas públicas"
  type        = bool
}
 
variable "ignore_public_acls" {
  description = "Ignorar ACLs públicas existentes"
  type        = bool
}
 
variable "restrict_public_buckets" {
  description = "Restringir acesso público a buckets"
  type        = bool
}
 
variable "lifecycle_enabled" {
  description = "Habilitar lifecycle policies"
  type        = bool
}
 
variable "transition_to_ia_days" {
  description = "Dias para transição para STANDARD_IA"
  type        = number
}
 
variable "transition_to_glacier_days" {
  description = "Dias para transição para GLACIER"
  type        = number
}
 
variable "expiration_days" {
  description = "Dias para expiração de objetos"
  type        = number
}
 
variable "logging_enabled" {
  description = "Habilitar logging de acesso"
  type        = bool
}
 
variable "log_bucket" {
  description = "Bucket para armazenar logs"
  type        = string
  default     = ""
}
 
variable "log_prefix" {
  description = "Prefixo para os logs"
  type        = string
}
 
#-------------------- S3 Bucket Website -------------------#
 
variable "s3_bucket_website_enabled" {
  description = "Enable website configuration on the bucket"
  type        = bool
}
 
variable "s3_bucket_website_index_document" {
  description = "Index document for the S3 website"
  type        = string
}
 
variable "s3_bucket_website_error_document" {
  description = "Error document for the S3 website"
  type        = string
}
 
#--------------------- VPC Endpoint ---------------------#
 
variable "enable_vpc_endpoint" {
  description = "Create a VPC endpoint for S3"
  type        = bool
}
 
variable "vpc_endpoint_vpc_id" {
  description = "VPC ID for the S3 VPC endpoint"
  type        = string
}
 
variable "vpc_endpoint_type" {
  description = "Type of VPC endpoint (e.g., Gateway, Interface)"
  type        = string
  default     = "Gateway"
}
 
variable "region" {
  description = "AWS region for the VPC endpoint service name"
  type        = string
}
 
variable "vpc_endpoint_route_table_ids" {
  description = "Route table IDs for the S3 VPC endpoint"
  type        = list(string)
}