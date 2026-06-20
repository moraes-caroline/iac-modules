locals {
  # Common locals for IAM role naming and tagging
  role_name_prefix = "${var.environment}-"
 
  # Merge common tags with environment-specific tags
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "trf-aws-iam-role"
    }
  )
}