# Provider AWS.
# Por quê: toda a infra deste lab fica nesta conta/região do operador (SSO).

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = local.project_name
      ManagedBy = "terraform"
      Purpose   = "learning-lab"
    }
  }
}
