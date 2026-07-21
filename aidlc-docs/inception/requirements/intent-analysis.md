# Intent Analysis — Fase 2 (HA + ALB)

## Pedido
Evoluir o lab da Fase 1 (API em Fargate) para arquitetura de **alta disponibilidade didática** com **ECS Service (desired=2)** + **Application Load Balancer** público, Target Group, health checks e demonstração de self-healing.

## Clareza
**Clara** nos objetivos e critérios de aceite; algumas decisões técnicas de lab ainda abertas (AZs, HTTPS, FastAPI vs menção a Flask).

## Tipo
**Enhancement / evolução de infraestrutura** (brownfield). Código da app: reutilizar sem mudanças significativas.

## Escopo
**Múltiplos componentes** — principalmente `infra/` (Terraform), `README`/`scripts` (fluxo DNS ALB), possivelmente SG/IAM policy docs. App Python: mínima ou nenhuma alteração.

## Complexidade
**Moderada a alta** (rede multi-AZ, ALB, service↔TG, segurança entre SGs, validação de failover).

## Profundidade de requisitos
**Standard** (RF/NFR + decisões + extensions + cenário de teste HA).

## Assunções iniciais (a confirmar)
| # | Assunção | Status |
|---|---|---|
| 1 | App permanece **FastAPI** (não migrar para Flask) | Confirmar |
| 2 | Health check do TG usa `GET /health` na porta 8000 | Confirmar |
| 3 | HTTP apenas (sem ACM/HTTPS) no lab | Confirmar |
| 4 | **2 AZs** / 2 subnets públicas para ALB + tasks | Confirmar |
| 5 | Tasks **sem** necessidade de IP público (tráfego via ALB); outbound via IGW/subnet pública | Confirmar |
| 6 | Prefixo/nomes `hello-fargate` mantidos | Confirmar |
| 7 | Continuar Terraform em `infra/` + SSO + script de push | Confirmar |

## Arquitetura proposta (rascunho — não implementar ainda)

```text
Internet
   ↓
ALB (público, HTTP :80)  — 2 AZs
   ↓
Target Group (HTTP :8000, HC /health)
   ↓
ECS Service desired_count=2
   ├── Task 1 (Fargate)  subnet AZ-a
   └── Task 2 (Fargate)  subnet AZ-b
```

### Decisões técnicas candidatas
- Listener HTTP :80 → TG
- SG ALB: ingress 80 do mundo (ou CIDR lab); egress para tasks
- SG tasks: ingress 8000 **somente do SG do ALB**; egress para ECR/logs
- Service `load_balancer { target_group_arn, container_name, container_port }`
- `assign_public_ip`: preferir `true` em subnet pública sem NAT (lab barato) **ou** `false` + NAT (mais caro) — perguntar
- Outputs: `alb_dns_name` (substitui IP da task no README)

### Riscos
| Risco | Mitigação |
|---|---|
| Custo ALB + 2 tasks | Destroy obrigatório; documentar |
| 1 AZ impede HA real do ALB | Preferir 2 AZs no lab |
| Policy IAM incompleta para ELB | Atualizar `docs/ecs-fargate-alb-policy.json` |
| State parcial Fase 1 | `destroy`/`apply` ou migrate in-place documentado |
| Menção Flask vs FastAPI | Confirmar zero rewrite |

## Backlog de implementação (alto nível — aprovação via plano depois)
1. Rede: 2ª subnet/AZ + SGs ALB/tasks
2. ALB + Target Group + listener + HC
3. ECS Service: desired=2 + attach TG; remover acesso “só por IP” do fluxo principal
4. Outputs/README/script: DNS ALB + roteiro self-healing
5. Build and Test: curl no DNS + exercício matar task
6. (Opcional) ajuste mínimo app só se HC exigir

## Próximo
Perguntas em `requirement-verification-questions.md` — **aguardar respostas** antes do documento formal de requirements e Workflow Planning.
