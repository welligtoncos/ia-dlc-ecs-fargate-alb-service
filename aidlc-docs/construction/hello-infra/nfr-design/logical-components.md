# Logical Components — `hello-infra`

Componentes lógicos que a Infrastructure Design / Terraform devem materializar. **Sem extras** além deste conjunto.

| Componente lógico | Responsabilidade | Materialização prevista (TF) |
|---|---|---|
| **VPC** | Isolamento de rede do lab (1 AZ) | `aws_vpc` |
| **Public Subnet** | Subnet com rota à internet | `aws_subnet` |
| **Internet Gateway** | Saída/entrada pública | `aws_internet_gateway` |
| **Public Route Table** | `0.0.0.0/0` → IGW | `aws_route_table` + association |
| **Security Group** | Ingress TCP 8000 de `allowed_cidr`; egress necessário p/ pull/logs | `aws_security_group` |
| **ECR Repository** | Armazena imagem `hello-fargate:latest` | `aws_ecr_repository` |
| **ECS Cluster** | Namespace Fargate | `aws_ecs_cluster` |
| **IAM Execution Role** | ECR pull + CloudWatch Logs | `aws_iam_role` + policies |
| **IAM Task Role** | Role da task (mínima) | `aws_iam_role` |
| **CloudWatch Log Group** | `/ecs/hello-fargate`, retention 7 | `aws_cloudwatch_log_group` |
| **Task Definition** | Fargate 256/512, port 8000, awslogs, imagem ECR:latest | `aws_ecs_task_definition` |
| **ECS Service** | desired_count=1, assign_public_ip, sem LB | `aws_ecs_service` |
| **Outputs** | ECR URL, (tentativa) IP público, IDs úteis | `outputs.tf` |

## Explicitamente fora
- ALB / Target Group
- Autoscaling
- Multi-AZ / NAT Gateway (subnet só pública)
- VPC Endpoints
- Elastic IP dedicado
- NACL custom
- null_resource de docker build

## Relação com outras unidades
- **hello-app**: produz o filesystem da imagem consumida pelo ECR/task
- **hello-tooling-docs**: fecha o dependency gap (push + fallback IP + docs recreate)
