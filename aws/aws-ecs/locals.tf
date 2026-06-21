variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 5000
}

variable "cpu" {
  default = "256"
}

variable "memory" {
  default = "512"
}

variable "tags" {
  type    = map(string)
  default = {}
}