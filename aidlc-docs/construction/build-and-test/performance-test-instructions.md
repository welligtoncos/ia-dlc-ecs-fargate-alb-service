# Performance Test Instructions — Lab Hello Fargate

## Purpose
Lab didático Hello World — **sem requisitos de carga/produção**.

## Performance Requirements
| Métrica | Expectativa do lab |
|---|---|
| Response time | Aceitável em curl manual (segundos) |
| Throughput / concurrent users | N/A |
| Error rate sob stress | N/A |

## Run Performance Tests
**N/A** — não executar JMeter/k6 neste escopo.

## Smoke (opcional, local)
Após `docker run` ou uvicorn:

```powershell
Measure-Command { curl http://127.0.0.1:8000/ }
```

Só para curiosidade didática; sem gate de SLO.

## Resiliency (mínimo, alinhado à extensão)
Documentado no README: curl `/` + `/health` e exercício destroy/recreate (RTO horas / recreate manual).
