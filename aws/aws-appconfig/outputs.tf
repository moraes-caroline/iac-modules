output "appconfig_applications" {
  value = {
    for app_key, app in aws_appconfig_application.this : app_key => {
      id          = app.id
      arn         = app.arn
      name        = app.name
      environment = aws_appconfig_environment.this[app_key].name
    }
  }
  description = "Map of all AppConfig applications with their IDs and ARNs."
}
 
output "appconfig_environments" {
  value       = { for key, env in aws_appconfig_environment.this : key => env.environment_id }
  description = "Map of application keys to their environment IDs."
}
 
output "appconfig_deployment_strategies" {
  value       = { for key, strategy in aws_appconfig_deployment_strategy.this : key => strategy.id }
  description = "Map of application keys to their deployment strategy IDs."
}
 
output "appconfig_configuration_profiles" {
  value = {
    for key, profile in aws_appconfig_configuration_profile.this : key => {
      id          = profile.configuration_profile_id
      arn         = profile.arn
      application = local.appconfig_profiles[key].app_key
      service     = local.appconfig_profiles[key].service_key
    }
  }
  description = "Map of all configuration profiles with their details."
}
 
output "appconfig_configuration_versions" {
  value = {
    for key, version in aws_appconfig_hosted_configuration_version.this : key => {
      version_number = version.version_number
      application    = local.appconfig_profiles[key].app_key
      service        = local.appconfig_profiles[key].service_key
    }
  }
  description = "Map of configuration versions for all services."
}
 
output "appconfig_deployments" {
  value = {
    for key, deployment in aws_appconfig_deployment.this : key => {
      deployment_number = deployment.deployment_number
      application       = local.appconfig_profiles[key].app_key
      service           = local.appconfig_profiles[key].service_key
      version           = aws_appconfig_hosted_configuration_version.this[key].version_number
    }
  }
  description = "Map of all deployments with their details."
}
 
output "appconfig_summary" {
  value = {
    for app_key, app in var.appconfig_applications : app_key => {
      application_id = aws_appconfig_application.this[app_key].id
      environment_id = aws_appconfig_environment.this[app_key].environment_id
      services = {
        for service_key, service in app.services :
        service_key => {
          profile_id        = aws_appconfig_configuration_profile.this["${app_key}-${service_key}"].configuration_profile_id
          profile_arn       = aws_appconfig_configuration_profile.this["${app_key}-${service_key}"].arn
          version_number    = try(aws_appconfig_hosted_configuration_version.this["${app_key}-${service_key}"].version_number, null)
          deployment_number = try(aws_appconfig_deployment.this["${app_key}-${service_key}"].deployment_number, null)
        }
      }
    }
  }
  description = "Complete summary of all applications with their services."
}