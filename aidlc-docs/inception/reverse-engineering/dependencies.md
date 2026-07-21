# Dependencies — Fase 1

| De | Para | Tipo |
|---|---|---|
| Tooling script | Terraform outputs (`infra/`) | runtime ops |
| Tooling script | Docker build `./app` | build |
| ECS Task | ECR image | runtime |
| ECS Task | CloudWatch Logs | runtime |
| Cliente HTTP | IP público da task:8000 | runtime |
| Terraform | AWS APIs (EC2, ECS, ECR, IAM, Logs) | provision |

## Evolução Fase 2 (prevista)
Cliente HTTP → **ALB DNS** → Target Group → Tasks (2x); service `load_balancer` block; SGs ALB↔tasks; provavelmente **2 subnets/AZs**.
