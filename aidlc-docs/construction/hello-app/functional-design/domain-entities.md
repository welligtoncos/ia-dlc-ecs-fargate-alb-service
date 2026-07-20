# Domain Entities — `hello-app`

## Entidades
Nenhuma entidade persistida. O “domínio” é só o contrato HTTP.

## DTOs / payloads

### HealthResponse (conceitual)
| Campo | Tipo | Valor |
|---|---|---|
| `status` | string | `"ok"` |
| `service` | string | `"hello-fargate"` |

### HelloResponse
| Campo | Tipo | Valor |
|---|---|---|
| (corpo) | string | `"Hello World"` |

### Error500Response (conceitual)
| Campo | Tipo | Exemplo |
|---|---|---|
| `detail` | string | `"internal_error"` |

## Agregados / relacionamentos
- N/A
