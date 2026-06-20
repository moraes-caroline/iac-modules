locals {
  # Flatten the structure: app_key => service_key => service details
  # Creates a flat map like: { "app1-api" => {...}, "app1-batch" => {...}, "app2-worker" => {...} }
  all_services = merge([
    for app_key, app in var.appconfig_applications : {
      for service_key, service in app.services :
      "${app_key}-${service_key}" => merge(service, {
        app_key     = app_key
        service_key = service_key
      })
    }
  ]...)
 
  # Create profiles map with GitHub content (null-safe)
  appconfig_profiles = {
    for key, service in local.all_services :
    key => merge(service, {
      config_content = try(data.github_repository_file.appsettings[key].content, null)
    })
  }
 
  # Filter profiles that actually have configuration content
  profiles_with_content = {
    for k, v in local.appconfig_profiles :
    k => v if v.config_content != null && v.config_content != ""
  }
 
  # Para cada configuration profile (chave = "${app_key}-${service_key}")
  # montamos: repo, environment, var_name, json_value
  profiles_repo_env = {
    for key, prof in aws_appconfig_configuration_profile.this :
    key => (
      # Recupera app_key e service_key das tags
      # tags.Application = app_key ; tags.Service = service_key
      can(local.all_services["${prof.tags.Application}-${prof.tags.Service}"])
&& try(trimspace(local.all_services["${prof.tags.Application}-${prof.tags.Service}"].github_repo), "") != ""
&& try(trimspace(local.all_services["${prof.tags.Application}-${prof.tags.Service}"].github_variant), "") != "" ?
      {
        app_key     = prof.tags.Application
        service_key = prof.tags.Service
 
        repo        = local.all_services["${prof.tags.Application}-${prof.tags.Service}"].github_repo
        environment = try(local.all_services["${prof.tags.Application}-${prof.tags.Service}"].github_env_name, var.github_environment_default)
 
        # Variant por serviço (se existir) ou global
        var_name = "APP_SETTINGS_${upper(
          try(local.all_services["${prof.tags.Application}-${prof.tags.Service}"].github_variant, var.appsettings_suffix)
        )}"
 
        # JSON
        json_value = jsonencode({
          ConfigSecretsAWS = {
            ApplicationId          = aws_appconfig_application.this[prof.tags.Application].id
            EnvironmentId          = aws_appconfig_environment.this[prof.tags.Application].environment_id
            ConfigurationProfileId = prof.configuration_profile_id
            AwsRegion              = "sa-east-1"
            SecretNamePrefix       = local.all_services["${prof.tags.Application}-${prof.tags.Service}"].github_secret_name
          }
        })
      } : null
    )
  }
 
  # filtra serviços sem repo definido
  profiles_repo_env_filtered = {
    for k, v in local.profiles_repo_env : k => v if v != null
  }
 
 
  # Deduplica repo:environment usando um SET de strings
  env_pair_keys = toset([
    for v in local.profiles_repo_env_filtered :
    "${v.repo}:${v.environment}"
  ])
 
  # Recria o mapa único repo:environment -> { repository, environment }
  env_pairs = {
    for key in local.env_pair_keys :
    key => {
      repository  = split(":", key)[0]
      environment = split(":", key)[1]
    }
  }
 
  # “Achata” para criar uma variável por profile
  variables_flat = {
    for k, v in local.profiles_repo_env_filtered :
    "${v.repo}:${v.environment}:${v.var_name}" => {
      repository    = v.repo
      environment   = v.environment
      variable_name = v.var_name
      value         = v.json_value
    }
  }
}