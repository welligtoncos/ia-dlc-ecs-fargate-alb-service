# Rede mínima didática: VPC + 1 subnet pública + IGW + rotas + security group.
# Por quê subnet pública + IP público na task: lab sem NAT e sem ALB — a task
# precisa puxar imagem do ECR e receber HTTP direto na porta 8000.

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "${local.project_name}-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.project_name}-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }

  tags = {
    Name = "${local.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group da task: ingresso na porta da API a partir de allowed_cidr.
# Egress amplo: necessário para pull do ECR e envio de logs ao CloudWatch.
resource "aws_security_group" "task" {
  name        = "${local.project_name}-task-sg"
  description = "Lab SG - HTTP ${local.container_port} from allowed_cidr"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "FastAPI / Uvicorn"
    from_port   = local.container_port
    to_port     = local.container_port
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    description = "Outbound for ECR pull and CloudWatch Logs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-task-sg"
  }
}
