# Interaction Diagrams — Fase 1

## Deploy + request

```mermaid
sequenceDiagram
  participant Op as Operador
  participant TF as Terraform
  participant ECR as ECR
  participant ECS as ECS Service
  participant Task as Fargate Task
  participant User as Cliente HTTP

  Op->>TF: apply
  TF->>ECR: cria repositório
  TF->>ECS: service desired=1
  Op->>ECR: build-and-push.ps1
  Op->>ECS: force-new-deployment
  ECS->>Task: sobe task com :latest
  User->>Task: GET / e /health via IP:8000
  Task-->>User: Hello World / JSON ok
```

## Self-healing na Fase 1
Com desired=1, se a única task cair, o Service tenta recriar — mas **sem ALB** o cliente que usava o IP antigo quebra até descobrir o novo IP.
