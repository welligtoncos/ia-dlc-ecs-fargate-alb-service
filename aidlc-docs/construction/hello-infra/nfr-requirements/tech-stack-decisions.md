# Tech Stack Decisions — `hello-infra`

## Stack escolhida

| Camada | Escolha | Motivo |
|---|---|---|
| IaC | Terraform `>= 1.5` | Padrão do lab; versão moderna com suporte estável |
| Provider | `hashicorp/aws` `~> 5.0` | API ECS/ECR/VPC atual |
| Região | `us-east-1` | Requisitos |
| Compute | ECS on **Fargate** | Sem gerenciar EC2 |
| Rede | VPC custom mínima, 1 AZ, subnet pública + IGW | Didático + barato |
| Registro de imagem | Amazon ECR (`hello-fargate`) | Fluxo imagem→task |
| Orquestração de task | `aws_ecs_service` desired_count=1, assign_public_ip | Sem ALB |
| Logs | CloudWatch Logs `/ecs/hello-fargate` (7 dias) | Observabilidade mínima |
| Auth operador | AWS SSO (fora do TF; documentado no tooling) | Requisitos |
| State | Local (`terraform.tfstate`) | Simplicidade; comentário S3 futuro |

## Convenções
- Prefixo de recursos: `hello-fargate`
- Image URI: `<account>.dkr.ecr.us-east-1.amazonaws.com/hello-fargate:latest`
- Variável `allowed_cidr` (default `0.0.0.0/0`) para SG :8000
- Variável `image_tag` **não** necessária — tag fixa `latest` (pode existir só como local/constante no TF)

## Explicitamente fora deste stack (unidade)
- ALB, autoscaling, multi-AZ, CI/CD, backend S3, HTTPS
