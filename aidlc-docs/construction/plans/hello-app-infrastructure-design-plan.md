# Plano Infrastructure Design — `hello-app` (mínimo)

Preencha cada `[Answer]:`. Avise quando terminar.

Esta unidade **não** provisiona AWS (já feito em `hello-infra`). Aqui só o “deploy target” do container.

---

## Question 1 — Escopo desta etapa
A) **Confirmar N/A de cloud**: só documentar Dockerfile como artefato de deploy; sem recursos AWS novos

B) Duplicar alguma definição ECS/ECR aqui (não recomendado — evita drift)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2 — CMD do container
A) `uvicorn app.main:app --host 0.0.0.0 --port 8000` (1 worker implícito)

B) Explicitar `--workers 1` no CMD

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — HEALTHCHECK no Dockerfile
A) Sem HEALTHCHECK no Dockerfile (ECS não usa isso obrigatoriamente; há `/health` HTTP)

B) Incluir `HEALTHCHECK` com `curl`/`wget` (aumenta imagem/complexidade)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 4 — Contexto de build
A) Build context = pasta `app/` (Dockerfile dentro de `app/`)

B) Build context = raiz do repo (Dockerfile em `app/` com paths ajustados)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Artefatos após respostas
- [x] `infrastructure-design/infrastructure-design.md`
- [x] `infrastructure-design/deployment-architecture.md`
- [x] Shared infra: N/A
