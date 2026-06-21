variable "repository_name" {
  description = "Nome do repositório ECR"
  type        = string
}

variable "image_tag_mutability" {
  description = "Mutabilidade da imagem"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Scan de vulnerabilidade"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
  default     = {}
}