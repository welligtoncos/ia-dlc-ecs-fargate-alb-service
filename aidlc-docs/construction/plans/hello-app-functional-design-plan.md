# Plano Functional Design — `hello-app` (mínimo)

Preencha cada `[Answer]:`. Avise quando terminar.

Unidade: FastAPI + Dockerfile. Escopo mínimo (Hello World). PBT: propriedades significativas provavelmente N/A.

---

## Question 1 — Forma do JSON de `/health`
A) `{"status": "ok"}`

B) `{"status": "ok", "service": "hello-fargate"}`

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 2 — Content-Type de `GET /`
A) Texto puro via `PlainTextResponse` / `media_type="text/plain"` com corpo `Hello World`

B) String FastAPI default (pode ser JSON-encoded string — menos alinhado ao RF)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — Estrutura de arquivos da app
A) Um único `app/main.py` + `app/requirements.txt` + `app/Dockerfile` (máxima simplicidade didática)

B) Pacote `app/` com `app/api.py` separado de `app/__init__.py` (um pouco mais “pro”)

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 4 — Tratamento de erros
A) Sem handlers custom — FastAPI default (404/422) basta para o lab

B) Handler genérico 500 retornando JSON simples

X) Other (please describe after [Answer]: tag below)

[Answer]: B

## Question 5 — PBT nesta unidade
A) Documentar **N/A** — respostas constantes, sem transformações/estado (recomendado)

B) Teste de propriedade trivial: `get_hello()` sempre retorna exatamente `"Hello World"` (exemplo mínimo com hypothesis, se fizer sentido)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 6 — Bind do Uvicorn no container
A) `0.0.0.0:8000` (obrigatório para acessível fora do container)

B) Other

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Artefatos após respostas
- [x] `functional-design/business-logic-model.md`
- [x] `functional-design/business-rules.md`
- [x] `functional-design/domain-entities.md`

## Compliance
| Extension | Nota |
|---|---|
| Resiliency | `/health` shallow |
| PBT | conforme Q5 |
| Security | N/A |
