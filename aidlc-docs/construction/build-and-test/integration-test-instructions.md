# Integration Test Instructions — Fase 2 (HA + ALB)

## Purpose
Validar interação `infra` ↔ `app` ↔ `tooling` via ALB, e o exercício de self-healing.

---

## Scenario 1 — Docker local (sem AWS)

**Setup:** Docker ligado.

```powershell
docker build -t hello-fargate:local ./app
docker run --rm -p 8000:8000 hello-fargate:local
```

```powershell
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/health
```

**Esperado:** Hello World + `{"status":"ok","service":"hello-fargate"}`.

**Cleanup:** Ctrl+C no `docker run`.

---

## Scenario 2 — Lab AWS via ALB (E2E principal)

**Setup:** SSO + `terraform apply` + `.\scripts\build-and-push.ps1`.

```powershell
$dns = terraform -chdir=infra output -raw alb_dns_name
curl http://$dns/
curl http://$dns/health
```

**Esperado:** Mesmas respostas; HTTP na **porta 80** (sem `:8000` no host do ALB).

**Verificação extra:**
```powershell
aws elbv2 describe-target-health --target-group-arn $(terraform -chdir=infra output -raw target_group_arn) --region us-east-1
aws ecs describe-services --cluster hello-fargate --services hello-fargate --region us-east-1 --query "services[0].{desired:desiredCount,running:runningCount}"
```

**Esperado:** 2 targets healthy (ou em transição breve); `desired=2`, `running=2`.

**Cleanup:** `terraform -chdir=infra destroy` (obrigatório).

---

## Scenario 3 — Self-healing (Resiliency)

**Pré-condição:** Scenario 2 OK.

```powershell
$cluster = "hello-fargate"
$service = "hello-fargate"
$region  = "us-east-1"

aws ecs list-tasks --cluster $cluster --service-name $service --desired-status RUNNING --region $region
aws ecs stop-task --cluster $cluster --task <TASK-ARN> --region $region

# Aguardar recreate
aws ecs describe-services --cluster $cluster --services $service --region $region `
  --query "services[0].{desired:desiredCount,running:runningCount,pending:pendingCount}"

$dns = terraform -chdir=infra output -raw alb_dns_name
curl http://$dns/health
```

**Esperado:** Service volta a `running=2`; TG healthy de novo; curl `/health` OK (pode falhar por poucos segundos).

**Cleanup:** destroy quando terminar o lab.

---

## Scenario 4 — Caminho alternativo IP (opcional)

```powershell
.\scripts\build-and-push.ps1 -ResolvePublicIp
```

**Nota:** SG task só aceita :8000 do ALB — curl no IP pode falhar. Não substitui o Scenario 2.
