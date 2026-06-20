#--------------------- IAM Role Outputs ---------------------#
 
output "iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.this.arn
}
 
output "iam_role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.this.name
}
 
output "iam_role_id" {
  description = "The ID of the IAM role"
  value       = aws_iam_role.this.id
}
 
output "iam_role_unique_id" {
  description = "The stable and unique ID of the IAM role"
  value       = aws_iam_role.this.unique_id
}
 
#--------------------- IAM Policy Outputs ---------------------#
 
output "appconfig_policy_arn" {
  description = "ARN of the AppConfig policy (if enabled)"
  value       = var.enable_appconfig_policy ? aws_iam_policy.appconfig[0].arn : null
}
 
output "secretsmanager_policy_arn" {
  description = "ARN of the Secrets Manager policy (if enabled)"
  value       = var.enable_secretsmanager_policy ? aws_iam_policy.secretsmanager[0].arn : null
}
 
output "kms_policy_arn" {
  description = "ARN of the KMS policy (if enabled)"
  value       = var.enable_kms_policy ? aws_iam_policy.kms[0].arn : null
}
 
output "s3_policy_arn" {
  description = "ARN of the S3 policy (if enabled)"
  value       = var.enable_s3_policy ? aws_iam_policy.s3[0].arn : null
}
 
output "mongodb_policy_arn" {
  description = "ARN of the Mongo policy (if enabled)"
  value       = var.enable_mongodb_policy ? aws_iam_policy.mongodb[0].arn : null
}
 
output "rdspostgresql_policy_arn" {
  description = "ARN of the Mongo policy (if enabled)"
  value       = var.enable_postgresql_policy ? aws_iam_policy.rdspostgresql[0].arn : null
}