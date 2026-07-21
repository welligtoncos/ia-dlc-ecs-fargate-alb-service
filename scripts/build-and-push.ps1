#Requires -Version 5.1
<#
.SYNOPSIS
  Login ECR, build da imagem FastAPI, push e force-new-deployment no ECS (lab HA + ALB).

.DESCRIPTION
  Caminho oficial do lab hello-fargate Fase 2.
  Lê outputs do Terraform em ./infra, faz build com contexto ./app,
  e sempre imprime o DNS do ALB para validação HTTP (porta 80).
  -ResolvePublicIp: caminho oficial alternativo (IP da task :8000).

.PARAMETER AwsProfile
  Nome do perfil AWS CLI/SSO (opcional). Se omitido, usa o default do ambiente.

.PARAMETER ResolvePublicIp
  Após o redeploy, tenta obter o IP público de uma task e imprime curls :8000 (alternativo ao ALB).

.EXAMPLE
  .\scripts\build-and-push.ps1

.EXAMPLE
  .\scripts\build-and-push.ps1 -AwsProfile meu-sso -ResolvePublicIp
#>
[CmdletBinding()]
param(
    [string]$AwsProfile = "",
    [switch]$ResolvePublicIp
)

$ErrorActionPreference = "Stop"

# Raiz do repo = pasta pai de scripts/
$RepoRoot = Split-Path -Parent $PSScriptRoot
$InfraDir = Join-Path $RepoRoot "infra"
$AppDir = Join-Path $RepoRoot "app"

if (-not (Test-Path (Join-Path $InfraDir "versions.tf"))) {
    throw "Diretório infra/ não encontrado em: $InfraDir"
}
if (-not (Test-Path (Join-Path $AppDir "Dockerfile"))) {
    throw "Dockerfile não encontrado em: $AppDir"
}

function Invoke-Aws {
    param([Parameter(Mandatory)][string[]]$AwsArgs)
    if ($AwsProfile) {
        & aws @AwsArgs --profile $AwsProfile
    }
    else {
        & aws @AwsArgs
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Comando aws falhou (exit $LASTEXITCODE): aws $($AwsArgs -join ' ')"
    }
}

function Get-TfOutputRaw {
    param([Parameter(Mandatory)][string]$Name)
    $value = & terraform "-chdir=$InfraDir" output -raw $Name 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao ler terraform output '$Name'. Rode 'terraform apply' em infra/ antes."
    }
    return $value.Trim()
}

Write-Host "==> Lendo outputs do Terraform (infra/)..." -ForegroundColor Cyan
$EcrUrl = Get-TfOutputRaw "ecr_repository_url"
$AwsRegion = Get-TfOutputRaw "aws_region"
$ClusterName = Get-TfOutputRaw "ecs_cluster_name"
$ServiceName = Get-TfOutputRaw "ecs_service_name"
$ImageUri = "${EcrUrl}:latest"

Write-Host "    ECR:     $EcrUrl"
Write-Host "    Região:  $AwsRegion"
Write-Host "    Cluster: $ClusterName"
Write-Host "    Service: $ServiceName"

Write-Host "==> Login no Amazon ECR..." -ForegroundColor Cyan
$password = if ($AwsProfile) {
    & aws ecr get-login-password --region $AwsRegion --profile $AwsProfile
}
else {
    & aws ecr get-login-password --region $AwsRegion
}
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($password)) {
    throw "Falha em 'aws ecr get-login-password'. Confira SSO (aws sso login) e permissões."
}
$password | docker login --username AWS --password-stdin $EcrUrl
if ($LASTEXITCODE -ne 0) {
    throw "docker login no ECR falhou."
}

Write-Host "==> docker build (contexto ./app)..." -ForegroundColor Cyan
docker build -t $ImageUri $AppDir
if ($LASTEXITCODE -ne 0) {
    throw "docker build falhou."
}

Write-Host "==> docker push $ImageUri ..." -ForegroundColor Cyan
docker push $ImageUri
if ($LASTEXITCODE -ne 0) {
    throw "docker push falhou."
}

Write-Host "==> Forçando novo deployment no ECS Service..." -ForegroundColor Cyan
Invoke-Aws @(
    "ecs", "update-service",
    "--cluster", $ClusterName,
    "--service", $ServiceName,
    "--force-new-deployment",
    "--region", $AwsRegion
) | Out-Null

Write-Host "OK: imagem publicada e redeploy solicitado." -ForegroundColor Green
Write-Host "Aguarde as tasks ficarem RUNNING e o Target Group healthy (1–2 min) antes do curl."

# Fluxo principal Fase 2: DNS do ALB (HTTP :80)
Write-Host "==> DNS do Application Load Balancer..." -ForegroundColor Cyan
$AlbDns = Get-TfOutputRaw "alb_dns_name"
if ([string]::IsNullOrWhiteSpace($AlbDns) -or $AlbDns -match "null|None") {
    throw "Output alb_dns_name vazio. Confirme 'terraform apply' (Fase 2 com ALB) em infra/."
}
Write-Host "ALB DNS: $AlbDns" -ForegroundColor Green
Write-Host ""
Write-Host "Validação (fluxo principal — porta 80, sem :8000):"
Write-Host "  curl http://${AlbDns}/"
Write-Host "  curl http://${AlbDns}/health"
Write-Host ""
Write-Host "Ou: terraform -chdir=infra output -raw alb_dns_name"

if ($ResolvePublicIp) {
    Write-Host "==> Resolvendo IP público (caminho oficial alternativo)..." -ForegroundColor Cyan
    $publicIp = $null
    try {
        $tfIp = & terraform "-chdir=$InfraDir" output -raw public_ip 2>$null
        if ($LASTEXITCODE -eq 0 -and $tfIp -and $tfIp -notmatch "null|None") {
            $publicIp = $tfIp.Trim()
        }
    }
    catch {
        # IP do output TF pode estar vazio — fallback CLI abaixo
    }

    if (-not $publicIp) {
        Write-Host "    Output public_ip vazio; tentando fallback via AWS CLI..."
        $taskArn = if ($AwsProfile) {
            & aws ecs list-tasks --cluster $ClusterName --service-name $ServiceName --desired-status RUNNING --region $AwsRegion --profile $AwsProfile --query "taskArns[0]" --output text
        }
        else {
            & aws ecs list-tasks --cluster $ClusterName --service-name $ServiceName --desired-status RUNNING --region $AwsRegion --query "taskArns[0]" --output text
        }
        if ($taskArn -and $taskArn -ne "None" -and $taskArn -ne "null") {
            $eniId = if ($AwsProfile) {
                & aws ecs describe-tasks --cluster $ClusterName --tasks $taskArn --region $AwsRegion --profile $AwsProfile --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value | [0]" --output text
            }
            else {
                & aws ecs describe-tasks --cluster $ClusterName --tasks $taskArn --region $AwsRegion --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value | [0]" --output text
            }
            if ($eniId -and $eniId -ne "None") {
                $publicIp = if ($AwsProfile) {
                    & aws ec2 describe-network-interfaces --network-interface-ids $eniId --region $AwsRegion --profile $AwsProfile --query "NetworkInterfaces[0].Association.PublicIp" --output text
                }
                else {
                    & aws ec2 describe-network-interfaces --network-interface-ids $eniId --region $AwsRegion --query "NetworkInterfaces[0].Association.PublicIp" --output text
                }
                if ($publicIp -eq "None" -or $publicIp -eq "null") { $publicIp = $null }
            }
        }
    }

    if ($publicIp) {
        Write-Host "IP público (alternativo): $publicIp" -ForegroundColor Green
        Write-Host "Nota: SG da task só aceita :8000 a partir do ALB — curl direto no IP pode falhar. Prefira o DNS do ALB."
        Write-Host "  curl http://${publicIp}:8000/"
        Write-Host "  curl http://${publicIp}:8000/health"
    }
    else {
        Write-Host "Não foi possível obter o IP agora. Aguarde tasks RUNNING e rode de novo com -ResolvePublicIp," -ForegroundColor Yellow
        Write-Host "ou: terraform -chdir=infra output public_ip_cli_fallback"
    }
}
