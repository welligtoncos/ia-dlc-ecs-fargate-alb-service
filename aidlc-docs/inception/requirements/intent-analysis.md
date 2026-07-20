# Análise de Intenção — FastAPI Hello World no Fargate (Terraform)

## Clareza do pedido
- **Parcialmente claro**: escopo funcional e fora de escopo bem definidos; faltam decisões técnicas/didáticas (região, networking, modelo ECS Task vs Service, build/push da imagem, estado do Terraform, etc.).
- Placeholder explícito: **região AWS** (`[PREENCHA]`).

## Tipo de pedido
- Novo projeto de aprendizado (greenfield de aplicação) em workspace que já tem AI-DLC + README de setup.

## Escopo estimado
- Múltiplos componentes: app FastAPI, Dockerfile, ECR, rede, IAM, ECS/Fargate, Terraform multi-arquivo, validação HTTP pública.

## Complexidade estimada
- Moderada (IaC + container + networking AWS), com forte requisito didático.

## Profundidade de requisitos
- **Standard / Comprehensive leve** — várias ambiguidades técnicas antes de planejar ou gerar código.

## Critério de sucesso (declarado pelo usuário)
1. `terraform apply`
2. Obter IP público via output
3. Abrir no navegador ou `curl` e ver `Hello World`
4. Entender o papel de cada componente AWS e bloco Terraform

## Fora de escopo (declarado)
- Autoscaling / múltiplas tasks, ALB, CI/CD, domínio/HTTPS, HA multi-AZ
