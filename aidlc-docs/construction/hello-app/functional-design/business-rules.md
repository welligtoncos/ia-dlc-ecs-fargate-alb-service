# Business Rules — `hello-app`

## BR-01 — Hello World
- `GET /` **deve** retornar exatamente o corpo texto `Hello World`
- Content-Type: `text/plain`

## BR-02 — Health
- `GET /health` **deve** retornar JSON com:
  - `status` = `"ok"`
  - `service` = `"hello-fargate"`
- Content-Type: `application/json`

## BR-03 — Sem autenticação
- Endpoints públicos (lab); sem auth/authorization na app

## BR-04 — Erros HTTP padrão
- Rotas inexistentes: comportamento default FastAPI (404)
- Validação de request (se houver no futuro): default 422
- Exceções não tratadas: handler 500 com JSON simples

## BR-05 — Porta e bind
- Processo escuta em `0.0.0.0:8000` no container

## BR-06 — Stateless
- Sem sessão, sem banco, sem cache
