data "github_repository_file" "appsettings" {
  for_each = {
    for key, service in local.all_services : key => service
    if service.github_repo != ""
  }
 
  repository = each.value.github_repo
  branch     = each.value.github_branch
  file       = each.value.github_file_path
 
  # Validate that GitHub token is provided
  lifecycle {
    precondition {
      condition     = var.github_token != ""
      error_message = "❌ GitHub token is required! Set TF_VAR_github_token environment variable or pass -var='github_token=YOUR_TOKEN'. This is mandatory for fetching appsettings from GitHub repositories."
    }
 
    postcondition {
      condition     = self.content != null && self.content != ""
      error_message = "❌ Failed to fetch configuration file for service '${each.key}'!\n  Repository: /${each.value.github_repo}\n  Branch: ${each.value.github_branch}\n  File: ${each.value.github_file_path}\n\nPossible causes:\n  1. File does not exist in the repository\n  2. Branch '${each.value.github_branch}' does not exist\n  3. Insufficient GitHub permissions\n  4. File path is incorrect"
    }
  }
}
 
resource "aws_appconfig_application" "this" {
  for_each = var.appconfig_applications
 
  name        = each.value.name
  description = each.value.description
  tags        = var.tags
}
 
resource "aws_appconfig_environment" "this" {
  for_each = var.appconfig_applications
 
  application_id = aws_appconfig_application.this[each.key].id
  name           = each.value.environment
  description    = "Environment ${each.value.environment} for ${each.value.name}"
  tags           = var.tags
}
 
resource "aws_appconfig_deployment_strategy" "this" {
  for_each = var.appconfig_applications
 
  name                           = each.value.deployment_strategy.name
  deployment_duration_in_minutes = each.value.deployment_strategy.deployment_duration_in_minutes
  growth_factor                  = each.value.deployment_strategy.growth_factor
  final_bake_time_in_minutes     = each.value.deployment_strategy.final_bake_time_in_minutes
  replicate_to                   = each.value.deployment_strategy.replicate_to
  tags                           = var.tags
}
 
resource "aws_appconfig_configuration_profile" "this" {
  for_each = local.appconfig_profiles
 
  application_id = aws_appconfig_application.this[each.value.app_key].id
  name           = each.value.profile_name
  description    = each.value.profile_description
  location_uri   = each.value.location_uri
  type           = each.value.type
 
  tags = merge(var.tags, {
    Application = each.value.app_key
    Service     = each.value.service_key
  })
}
 
# Hosted Configuration Versions (one per service with incremental versioning)
# AWS AppConfig automatically increments version numbers (1, 2, 3...) when content changes
resource "aws_appconfig_hosted_configuration_version" "this" {
  for_each = local.profiles_with_content
 
  application_id           = aws_appconfig_application.this[each.value.app_key].id
  configuration_profile_id = aws_appconfig_configuration_profile.this[each.key].configuration_profile_id
  content                  = each.value.config_content
  content_type             = each.value.content_type
  description              = "Configuration for ${each.value.service_key} service in ${each.value.app_key}"
 
  lifecycle {
    precondition {
      condition     = each.value.config_content != ""
      error_message = "❌ Configuration content is empty for service '${each.key}'! Check if the file '${each.value.github_file_path}' exists in repository '${each.value.github_repo}' on branch '${each.value.github_branch}'."
    }
  }
}
 
resource "aws_appconfig_deployment" "this" {
  for_each = local.profiles_with_content
 
  application_id           = aws_appconfig_application.this[each.value.app_key].id
  environment_id           = aws_appconfig_environment.this[each.value.app_key].environment_id
  configuration_profile_id = aws_appconfig_configuration_profile.this[each.key].configuration_profile_id
  configuration_version    = aws_appconfig_hosted_configuration_version.this[each.key].version_number
  deployment_strategy_id   = aws_appconfig_deployment_strategy.this[each.value.app_key].id
  description              = "Deployment of ${each.value.service_key} to ${var.appconfig_applications[each.value.app_key].environment} - Version ${aws_appconfig_hosted_configuration_version.this[each.key].version_number}"
 
  tags = merge(var.tags, {
    Application = each.value.app_key
    Service     = each.value.service_key
    Environment = var.appconfig_applications[each.value.app_key].environment
    Version     = tostring(aws_appconfig_hosted_configuration_version.this[each.key].version_number)
  })
}
 
resource "github_actions_environment_variable" "appsettings_json" {
  for_each = var.enable_github_variables ? local.variables_flat : {}
 
  repository    = each.value.repository
  environment   = each.value.environment
  variable_name = each.value.variable_name
  value         = each.value.value
}