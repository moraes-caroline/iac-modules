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
    Project_Leader_Crefisa = ""
    Domain                 = ""
    Sub_Domain             = ""
    Acronym                = ""
  }
}
 
#--------------------- AWS Environment -------------------#
 
variable "environment" {
  description = "The environment for resource deployment (e.g., 'dev', 'hmg', 'prd')."
  type        = string
}

#--------------------- Token appconfig ---------------------#
 
variable "enable_github_variables" {
  type = bool
}

variable "github_token" {
  type = string
}

variable "appconfig_applications" {
  type = any
}

variable "tags" {
  type = map(string)
}
#--------------------- IAM Role ---------------------#
 
variable "iam_role_name" {
  description = "The name of the IAM role"
  type        = string
}
 
variable "iam_role_description" {
  description = "The description of the IAM role"
  type        = string
  default     = ""
}
 
variable "iam_role_assume_role_policy" {
  description = "The assume role policy document (JSON) for the IAM role"
  type        = string
}
 
variable "iam_role_force_detach_policies" {
  description = "Whether to force detaching any policies the role has before destroying it"
  type        = bool
  default     = false
}
 
variable "iam_role_max_session_duration" {
  description = "Maximum session duration (in seconds) for the IAM role. Valid values: 3600 to 43200"
  type        = number
  default     = 3600
}
 
variable "iam_role_path" {
  description = "The path to the IAM role"
  type        = string
  default     = "/"
}
 
variable "iam_role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role"
  type        = string
  default     = null
}
 
#--------------------- IAM Policy Toggles ---------------------#
 
variable "enable_appconfig_policy" {
  description = "Enable AWS AppConfig access policy"
  type        = bool
  default     = false
}
 
variable "enable_secretsmanager_policy" {
  description = "Enable AWS Secrets Manager access policy"
  type        = bool
  default     = false
}
 
variable "enable_kms_policy" {
  description = "Enable AWS KMS access policy"
  type        = bool
  default     = false
}
 
variable "enable_s3_policy" {
  description = "Enable AWS S3 access policy"
  type        = bool
  default     = false
}
 
variable "enable_mongodb_policy" {
  description = "Enable Mongo Atlas access policy"
  type        = bool
  default     = false
}
 
variable "enable_elasticache_policy" {
  description = "Enable AWS ElastiCache access policy"
  type        = bool
  default     = false
}
 
variable "enable_postgresql_policy" {
  description = "Enable RDS PostgreSql access policy"
  type        = bool
  default     = false
}
 
#--------------------- Resource ARNs ---------------------#
 
variable "appconfig_resource_arns" {
  description = "List of AppConfig resource ARNs (applications, environments, configurations)"
  type        = list(string)
  default     = ["*"]
}
 
variable "secretsmanager_resource_arns" {
  description = "List of Secrets Manager secret ARNs"
  type        = list(string)
  default     = ["*"]
}
 
variable "kms_resource_arns" {
  description = "List of KMS key ARNs"
  type        = list(string)
  default     = ["*"]
}
 
variable "s3_resource_arns" {
  description = "List of S3 bucket ARNs"
  type        = list(string)
  default     = ["*"]
}
 
 
variable "s3_actions" {
  description = "List of S3 actions to allow"
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
    "s3:ListBucket"
  ]
}
 
variable "mongodb_resource_arns" {
  description = "List of Mongo resource ARNs (applications, environments, configurations)"
  type        = list(string)
  default     = ["*"]
}
 
variable "elasticache_resource_arns" {
  description = "List of ElastiCache cluster/replication group/serverless cache ARNs"
  type        = list(string)
  default     = ["*"]
}
 
variable "elasticache_actions" {
  description = "List of ElastiCache actions to allow"
  type        = list(string)
  default = [
    "elasticache:Connect"
  ]
}
 
variable "rdspostgresql_resource_arns" {
  description = "List of PostgreSql resource ARNs (applications, environments, configurations)"
  type        = list(string)
  default     = ["*"]
}
 
#--------------------- Additional Managed Policies ---------------------#
 
variable "iam_managed_policy_arns" {
  description = "List of additional AWS managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}
