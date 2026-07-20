# Serviços e Orquestração

## Serviços runtime (AWS)

### EcsFargateService (parte de CloudInfra)
- **Tipo**: `aws_ecs_service` com `desired_count = 1`, `launch_type = FARGATE`, `assign_public_ip = true`, **sem load balancer**.
- **Responsabilidade**: Manter uma task da ApiApp (imagem no ECR) em execução.
- **Não é**: ALB, autoscaling, multi-AZ.

### EcrRepository (parte de CloudInfra)
- Armazena a imagem produzida por ContainerImage + Tooling.

## Serviço conceitual de lab

### LabOrchestration
- **Tipo**: Orquestração **didática** (não é um processo/daemon adicional).
- **Responsabilidade**: Descrever e coordenar o fluxo ponta a ponta usando passos manuais + scripts.
- **Fluxo**:
  1. `aws sso login`
  2. `terraform apply` (CloudInfra)
  3. `scripts/build-and-push.ps1` (Tooling ← ContainerImage ← ApiApp)
  4. Garantir que o service puxe a imagem (redeploy se necessário)
  5. Obter IP (`output_public_ip` e/ou `resolve_public_ip_fallback`)
  6. Validar `curl` `/` e `/health`
  7. `terraform destroy` (obrigatório no checklist)

- **Participantes**: operador humano + Tooling + CloudInfra + ApiApp (via container).

## Padrão de orquestração
- **Estilo**: Pipeline manual documentado (direct/in-place deploy).
- **Rollback**: destroy + reapply / re-push imagem (conforme requisitos Resiliency).
- **Sem** orquestrador Kubernetes/Step Functions/CI-CD neste escopo.
