# Plano NFR Design — `hello-app`

Preencha cada `[Answer]:`. Avise quando terminar.

Contexto: FastAPI mínimo, 1 worker, non-root, TestClient, logs stdout, PBT N/A. AWS fica na unidade infra.

---

## Question 1 — Padrão de resiliência na app
A) Apenas `/health` shallow + handler 500 — sem retries/circuit breaker (sem deps externas)

B) Adicionar middleware de timeout (desnecessário neste Hello World)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 2 — Escalabilidade na app
A) **N/A** — escala vem do ECS desired_count (fixo em 1 na infra); app stateless

B) Documentar “stateless pattern” explicitamente no design (sem código extra)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 3 — Segurança na app (além de non-root)
A) Mínimo: sem secrets na imagem; sem CORS custom (default)

B) Adicionar headers de segurança básicos (ex. middleware SecurityHeaders) — opcional para lab

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 4 — Componentes lógicos da app
A) Apenas: API router + FastAPI app + exception handler + container runtime

B) Separar “HealthService” / “HelloService” como classes (overkill para lab)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

## Question 5 — Camada de teste
A) Um arquivo `tests/test_api.py` (ou `app/tests/`) com TestClient

B) Testes no mesmo diretório `app/test_main.py`

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Artefatos após respostas
- [x] `nfr-design/nfr-design-patterns.md`
- [x] `nfr-design/logical-components.md`
