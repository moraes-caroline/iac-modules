variable "name" {
  type        = string
  description = "Nome da IAM Policy"
}
 
variable "description" {
  type    = string
  default = "IAM Policy gerada externamente"
}
 
variable "path" {
  type    = string
  default = "/"
}
 
variable "policy" {
  type        = string
  description = "JSON da policy já montado pelo caller"
}
 
variable "tags" {
  type    = map(string)
  default = {}
}