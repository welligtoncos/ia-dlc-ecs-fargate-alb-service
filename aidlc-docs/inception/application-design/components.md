# Componentes — Lab FastAPI + Fargate

## Visão geral
Quatro componentes lógicos + um serviço conceitual de orquestração do lab (`LabOrchestration`, ver `services.md`).

| Componente | Pasta / artefatos | Propósito |
|---|---|---|
| **ApiApp** | `app/` (código Python) | API HTTP mínima FastAPI/Uvicorn |
| **ContainerImage** | `app/Dockerfile` (+ deps) | Empacota a API em imagem OCI |
| **CloudInfra** | `infra/*.tf` | Provisiona AWS (rede, ECR, IAM, ECS/Fargate, logs) |
| **Tooling** | `scripts/`, partes do `README.md` | Build/push, fallback de IP, guias operacionais do lab |

---

## ApiApp
- **Responsabilidades**: Expor `GET /` (texto Hello World) e `GET /health` (JSON); escutar na porta 8000.
- **Não faz**: Provisionar AWS, build/push de imagem, obter IP público.
- **Interfaces**: HTTP na porta 8000; logs em stdout/stderr.

## ContainerImage
- **Responsabilidades**: Definir imagem Docker (Python ARG default 3.12 slim), instalar deps, comando Uvicorn na 8000.
- **Não faz**: Criar repositório ECR (isso é CloudInfra); push (Tooling).
- **Interfaces**: Artefato de imagem local tagueável para ECR.

## CloudInfra
- **Responsabilidades**: VPC mínima 1 AZ, subnet pública, IGW, rotas, SG (8000), ECR, IAM roles, cluster ECS, task definition Fargate, service `desired_count=1` com IP público, log driver awslogs/CloudWatch, outputs (incl. tentativa de IP público).
- **Não faz**: Build/push da imagem; critério de sucesso curl (Tooling/README).
- **Interfaces**: Estado Terraform; outputs; recursos AWS com prefixo `hello-fargate`.

## Tooling
- **Responsabilidades**: `scripts/build-and-push.ps1`; comando/script de fallback para IP da ENI; documentação operacional no README (SSO, curl, destroy).
- **Não faz**: Definir recursos AWS (exceto consumir outputs/ARNs).
- **Interfaces**: CLI AWS/Docker; scripts PowerShell.

## Observabilidade
- **Não é componente separado** — CloudWatch Logs pertence a **CloudInfra**; ApiApp apenas escreve em stdout.
