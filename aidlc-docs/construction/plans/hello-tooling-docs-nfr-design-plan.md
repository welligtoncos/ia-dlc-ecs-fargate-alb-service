# Plano NFR Design — `hello-tooling-docs`

Preencha cada `[Answer]:`. Avise quando terminar.

---

## Question 1 — Padrão LabOrchestration no README
A) Seções numeradas fixas: SSO → terraform apply → build-and-push → curl → destroy

B) Diagrama + seções (mesmo fluxo)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2 — Tratamento de erro no script
A) `$ErrorActionPreference = 'Stop'` + mensagens claras se docker/aws/terraform outputs falharem

B) Continuar mesmo com avisos (menos seguro)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — Região/ECR no script
A) Ler `terraform output -raw` de `infra/` (ecr_repository_url, region, cluster/service) quando possível

B) Parâmetros obrigatórios `-EcrUrl` / `-Region` sem ler Terraform

C) Híbrido: tenta outputs TF; senão usa parâmetros

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 4 — Componentes lógicos
A) ScriptBuildPush + DocLabOrchestration + GitIgnore + IamPolicyDoc

B) Um único “ToolingBundle” sem separar no design

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 5 — Teste de resiliência mínimo (RESILIENCY-14)
A) Documentar no README: curl `/` e `/health` + exercício destroy/recreate

B) Só curl; destroy só mencionado

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Artefatos após respostas
- [x] `nfr-design/nfr-design-patterns.md`
- [x] `nfr-design/logical-components.md`
