# Amazon ECR: repositório da imagem da API.
# Por quê ECR: a task Fargate precisa puxar a imagem de um registry na AWS
# (ou público). O push é feito pelo script da unidade tooling — não pelo Terraform.

resource "aws_ecr_repository" "app" {
  name                 = local.project_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = local.project_name
  }
}
