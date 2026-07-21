# Variáveis configuráveis do lab (Fase 2 HA + ALB).
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
  description = "CIDR da subnet pública AZ-a (default 10.0.1.0/24)."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_b" {
  description = "CIDR da subnet pública AZ-b (default 10.0.2.0/24)."
  type        = string
  default     = "10.0.2.0/24"
}

variable "allowed_cidr" {
  description = "CIDR liberado para HTTP :80 no ALB. Default aberto — documente o risco no README."
  type        = string
  default     = "0.0.0.0/0"
}
