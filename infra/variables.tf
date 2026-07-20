# Variáveis configuráveis do lab.
# Valores sensíveis de conta vêm do SSO/credenciais do operador — não coloque secrets aqui.

variable "aws_region" {
  description = "Região AWS do lab (default us-east-1)."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR da VPC didática."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR da única subnet pública (1 AZ)."
  type        = string
  default     = "10.0.1.0/24"
}

variable "allowed_cidr" {
  description = "CIDR liberado para acessar a porta 8000. Default aberto — documente o risco no README."
  type        = string
  default     = "0.0.0.0/0"
}
