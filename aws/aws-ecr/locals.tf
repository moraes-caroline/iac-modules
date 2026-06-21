locals {
  default_tags = {
    ManagedBy = "Terraform"
    Project   = "application1"
  }

  tags = merge(local.default_tags, var.tags)
}
