#--------------------- IAM Role ---------------------#
 
resource "aws_iam_role" "this" {
  name                  = var.iam_role_name
  description           = var.iam_role_description
  assume_role_policy    = var.iam_role_assume_role_policy
  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary
  tags                  = var.tags
}
 
#--------------------- AppConfig Policy ---------------------#
 
resource "aws_iam_policy" "appconfig" {
  count = var.enable_appconfig_policy ? 1 : 0
 
  name        = "${var.iam_role_name}-appconfig-policy"
  description = "Policy for AWS AppConfig access"
  path        = var.iam_role_path
  tags        = var.tags
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "appconfig:GetConfiguration",
          "appconfig:GetLatestConfiguration",
          "appconfig:StartConfigurationSession"
        ]
        Resource = var.appconfig_resource_arns
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "appconfig" {
  count = var.enable_appconfig_policy ? 1 : 0
 
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.appconfig[0].arn
}
resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
 
#--------------------- Secrets Manager Policy ---------------------#
 
resource "aws_iam_policy" "secretsmanager" {
  count = var.enable_secretsmanager_policy ? 1 : 0
 
  name        = "${var.iam_role_name}-secretsmanager-policy"
  description = "Policy for AWS Secrets Manager access"
  path        = var.iam_role_path
  tags        = var.tags
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secretsmanager_resource_arns
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "secretsmanager" {
  count = var.enable_secretsmanager_policy ? 1 : 0
 
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.secretsmanager[0].arn
}
 
#--------------------- KMS Policy ---------------------#
 
resource "aws_iam_policy" "kms" {
  count = var.enable_kms_policy ? 1 : 0
 
  name        = "${var.iam_role_name}-kms-policy"
  description = "Policy for AWS KMS access"
  path        = var.iam_role_path
  tags        = var.tags
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey"
        ]
        Resource = var.kms_resource_arns
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "kms" {
  count = var.enable_kms_policy ? 1 : 0
 
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.kms[0].arn
}
 
#--------------------- S3 Policy ---------------------#
 
resource "aws_iam_policy" "s3" {
  count = var.enable_s3_policy ? 1 : 0
 
  name        = "${var.iam_role_name}-s3-policy"
  description = "Policy for AWS S3 access"
  path        = var.iam_role_path
  tags        = var.tags
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = var.s3_actions
        Resource = concat(
          var.s3_resource_arns,
          [for arn in var.s3_resource_arns : "${arn}/*"]
        )
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "s3" {
  count = var.enable_s3_policy ? 1 : 0
 
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3[0].arn
}
 
#--------------------- Mongo Atlas Policy ---------------------#
 
resource "aws_iam_policy" "mongodb" {
  count = var.enable_mongodb_policy ? 1 : 0
 
  name        = "${var.iam_role_name}-mongodb-policy"
  description = "Policy for MonogoDb access"
  path        = var.iam_role_path
  tags        = var.tags
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sts:GetCallerIdentity"]
        Resource = ["*"]
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "mongodb" {
  count = var.enable_mongodb_policy ? 1 : 0
 
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.mongodb[0].arn
}
 
#--------------------- RDS Postgress Policy ---------------------#
 
resource "aws_iam_policy" "rdspostgresql" {
  count = var.enable_postgresql_policy ? 1 : 0
 
  name        = "${var.iam_role_name}-rdspostgresql-policy"
  description = "Policy for RDS Postgress access"
  path        = var.iam_role_path
  tags        = var.tags
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["rds-db:connect"]
        Resource = var.rdspostgresql_resource_arns
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "rdspostgresql" {
  count = var.enable_postgresql_policy ? 1 : 0
 
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.rdspostgresql[0].arn
}
 
#--------------------- ElastiCache Policy ---------------------#
 
resource "aws_iam_policy" "elasticache" {
  count = var.enable_elasticache_policy ? 1 : 0
 
  name        = "${var.iam_role_name}-elasticache-policy"
  description = "Policy for AWS ElastiCache access"
  path        = var.iam_role_path
  tags        = var.tags
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.elasticache_actions
        Resource = var.elasticache_resource_arns
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "elasticache" {
  count = var.enable_elasticache_policy ? 1 : 0
 
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.elasticache[0].arn
}
 
#--------------------- Additional Managed Policies ---------------------#
 
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = toset(var.iam_managed_policy_arns)
 
  role       = aws_iam_role.this.name
  policy_arn = each.value
}