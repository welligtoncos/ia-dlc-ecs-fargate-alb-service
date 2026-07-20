# Story Map Sintético → Unidades

User Stories foi pulado. Mapeamento usa **RF-01..RF-09** e **critérios de sucesso (CS-1..CS-5)**.

## Requisitos funcionais

| ID | Resumo | Unidade primária | Unidades de apoio |
|---|---|---|---|
| RF-01 | API FastAPI `/` e `/health` porta 8000 | `hello-app` | — |
| RF-02 | Dockerfile + push ECR | `hello-app` | `hello-infra` (ECR), `hello-tooling-docs` (push) |
| RF-03 | Script `build-and-push.ps1` | `hello-tooling-docs` | `hello-app`, `hello-infra` |
| RF-04 | Terraform multi-arquivo | `hello-infra` | — |
| RF-05 | SG + IP público | `hello-infra` | — |
| RF-06 | Output IP + fallback CLI | `hello-infra` + `hello-tooling-docs` | — |
| RF-07 | Validação curl + checklist destroy | `hello-tooling-docs` | `hello-infra` |
| RF-08 | README didático + comentários TF | `hello-tooling-docs` (README) | `hello-infra` (comentários .tf) |
| RF-09 | Documentar AWS SSO | `hello-tooling-docs` | — |

## Critérios de sucesso

| ID | Critério | Unidades envolvidas |
|---|---|---|
| CS-1 | `terraform apply` (+ imagem via script) | `hello-infra`, `hello-tooling-docs`, `hello-app` |
| CS-2 | Obter IP público (output e/ou CLI) | `hello-infra`, `hello-tooling-docs` |
| CS-3 | curl/navegador Hello World | `hello-app` (runtime), docs em tooling |
| CS-4 | Entender papel de cada componente | README/comentários (`hello-tooling-docs`, `hello-infra`) |
| CS-5 | Checklist destroy obrigatório | `hello-tooling-docs`, `hello-infra` |

## Cobertura
- Todos os RF-01..RF-09 atribuídos: **sim**
- Todos os CS-1..CS-5 atribuídos: **sim**
