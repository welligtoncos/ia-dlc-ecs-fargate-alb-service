# Plano NFR Requirements — `hello-tooling-docs` Fase 2 (mínimo)

Preencha cada `[Answer]:`. Avise quando terminar.  
Security Baseline: **OFF**. Resiliency: **ON** (documentar HA/self-healing). PBT: **OFF**.  
Infra Design desta unidade: **N/A** (sem recursos AWS novos).

Escopo: README (DNS ALB + self-healing) + delta mínimo em `scripts/build-and-push.ps1` + policy IAM se necessário.

---

## Question 1 — Como o script expõe o DNS do ALB
A) Sempre imprimir `alb_dns_name` + exemplos `curl http://<dns>/` e `/health` após o push (recomendado)

B) Só imprimir ALB com um novo switch (ex.: `-ShowAlbDns`); sem switch, só mensagem genérica

C) Não mudar o script — só documentar no README (`terraform output -raw alb_dns_name`)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 2 — Switch `-ResolvePublicIp` (caminho alternativo Q5=B)
A) Manter `-ResolvePublicIp` como caminho **oficial alternativo** (IP da task); o fluxo principal do lab vira DNS ALB

B) Remover `-ResolvePublicIp` do script e do README (só ALB)

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 3 — Roteiro self-healing no README
A) Incluir exercício didático: listar tasks → `stop-task` / kill uma task → observar ECS recriar até desired=2 + TG healthy (comandos AWS CLI + o que olhar no console)

B) Só mencionar self-healing em 1 parágrafo, sem comandos passo a passo

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 4 — Estrutura do README Fase 2
A) Reescrever o README do lab para HA+ALB (fluxo principal via DNS); manter seções locais/Docker e AI-DLC breve; atualizar diagrama/lições (2 AZs, ALB, SG alb→task)

B) Manter README Fase 1 intacto e acrescentar só uma seção “Fase 2” no final

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 5 — Policy IAM em `docs/`
A) Revisar `docs/ecs-fargate-alb-policy.json` só se faltar ação ELB óbvia; senão, atualizar comentário/README dizendo que a policy agora cobre o lab com ALB

B) Expandir a policy com ações ELB adicionais agora (liste em Other se souber quais)

C) Não tocar em `docs/` nesta unidade

X) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 6 — Ênfase em custo / destroy
A) Destacar no README: custo ALB + 2 tasks; `terraform destroy` obrigatório ao fim do lab; aviso de possible replace no `plan` in-place Fase 1→2

B) Mencionar destroy só de passagem (sem alerta de custo ALB)

X) Other (please describe after [Answer]: tag below)

[Answer]: A
