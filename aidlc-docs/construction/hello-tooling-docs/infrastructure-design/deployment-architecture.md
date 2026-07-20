# Deployment Architecture — `hello-tooling-docs`

## Papel operacional

```text
[Operador]
   |  aws sso login
   |  terraform -chdir=infra apply
   |  scripts/build-and-push.ps1  (lê outputs de ./infra, build ./app)
   |  curl http://<IP>:8000/  e  /health
   |  terraform -chdir=infra destroy
   v
[Lab completo / custo ~zero]
```

## Resolução de caminhos no script
1. Determinar diretório do script (`$PSScriptRoot`)
2. Raiz do repo = parent de `scripts/`
3. `InfraDir` = `<raiz>/infra`
4. `AppDir` = `<raiz>/app`

## Diagrama Mermaid

```mermaid
flowchart TD
  Op["Operador"] --> SSO["aws sso login"]
  SSO --> TF["terraform apply infra/"]
  TF --> Script["build-and-push.ps1"]
  Script --> Docker["docker build ./app"]
  Script --> ECR["docker push ECR"]
  Script --> ECS["force-new-deployment"]
  ECS --> Curl["curl / e /health"]
  Curl --> Destroy["terraform destroy"]
```

## Alternativa em texto
SSO → apply → script (build/push/redeploy) → validação HTTP → destroy.
