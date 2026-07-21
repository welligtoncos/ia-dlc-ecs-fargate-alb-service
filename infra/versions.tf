# Versões do Terraform e providers.
# Por quê: fixar faixas evita surpresas ao rodar o lab em máquinas diferentes.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # State LOCAL (simples para estudo).
  # Migração futura para S3 (+ DynamoDB lock): descomente um backend "s3" { ... }
  # e rode `terraform init -migrate-state` — não é necessário neste lab.
}

locals {
  # Prefixo fixo dos recursos (requisito do lab).
  project_name   = "hello-fargate"
  container_port = 8000
  image_tag      = "latest"
  fargate_cpu    = "256"
  fargate_memory = "512"
}
