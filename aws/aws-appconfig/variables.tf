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
 
#---------------------- GitHub Integration ---------------------#
 
variable "github_token" {
  description = "GitHub token for accessing private repositories"
  type        = string
  sensitive   = true
}
 
# Environment padrão caso o serviço não defina um (ex.: dev)
variable "github_environment_default" {
  description = "Environment padrão do repo (ex.: dev), se o serviço não especificar"
  type        = string
  default     = "dev"
}
 
# Sufixo padrão do nome APP_SETTINGS_<SUFIXO> (pode ser sobrescrito por serviço)
variable "appsettings_suffix" {
  description = "Sufixo default para compor APP_SETTINGS_<SUFIXO>"
  type        = string
  default     = "DEFAULT"
}
 
 
#---------------------- AppConfig Applications (Multiple) ---------------------#
 
variable "appconfig_applications" {
  description = "Map of AppConfig applications with their services and configurations"
  type = map(object({
    name        = string
    description = string
    environment = string
    deployment_strategy = object({
      name                           = string
      deployment_duration_in_minutes = number
      growth_factor                  = number
      final_bake_time_in_minutes     = number
      replicate_to                   = string
    })
    services = map(object({
      profile_name        = string
      profile_description = string
      location_uri        = string
      type                = string
      content_type        = string
      github_repo         = string
      github_branch       = string
      github_file_path    = string
      github_env_name     = optional(string)
      github_secret_name  = optional(string)
      github_variant      = optional(string)
    }))
  }))
}
 
#---------------------- Habilitar / Desabilitar a criação das variaveis do appconfig -------#
 
variable "enable_github_variables" {
  description = "Se true, cria variáveis de environment no GitHub. Se false, não cria nada."
  type        = bool
  default     = false
}