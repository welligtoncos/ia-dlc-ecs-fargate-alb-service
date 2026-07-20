# Análise de Intenção — FastAPI Hello World no Fargate (Terraform)

## Clareza do pedido
- **Clara** após respostas das perguntas 1–18 (região, rede, service+IP, scripts, layout, docs, extensions).

## Tipo de pedido
- Novo projeto de aprendizado (greenfield de aplicação) em workspace com AI-DLC + README de setup.

## Escopo estimado
- Múltiplos componentes: `app/` FastAPI, Dockerfile, `scripts/build-and-push.ps1`, `infra/` Terraform, README didático.

## Complexidade estimada
- Moderada (IaC + container + networking), prioridade didática.

## Profundidade de requisitos
- **Standard**

## Critério de sucesso
1. `terraform apply` (+ imagem no ECR via script)
2. IP público (output e/ou CLI)
3. `curl`/navegador → Hello World
4. Entender cada componente
5. `terraform destroy` no checklist

## Fora de escopo
- Autoscaling, ALB, CI/CD, domínio/HTTPS, HA/multi-AZ

## Pendência
- Esclarecimentos Resiliency (extensão habilitada) em `resiliency-clarification-questions.md`
