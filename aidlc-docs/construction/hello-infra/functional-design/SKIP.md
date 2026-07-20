# Functional Design — `hello-infra` (PULADO)

## Decisão
**Status**: N/A / PULADO para esta unidade.

## Justificativa
A unidade `hello-infra` provisiona recursos AWS via Terraform (rede, ECR, IAM, ECS). Não há:
- modelo de domínio de negócio
- regras de negócio / algoritmos
- entidades de aplicação

Isso está alinhado ao plano de execução (“Functional Design mínimo na unidade `app`; N/A nas demais”).

## Encaminhamento
Próxima etapa da unidade: **NFR Requirements**.
O detalhamento de recursos AWS ocorre em **Infrastructure Design**.
