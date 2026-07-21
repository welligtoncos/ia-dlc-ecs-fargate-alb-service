# Application Load Balancer + Target Group + Security Groups (Fase 2).
# Fluxo: Internet → ALB :80 → TG (ip:8000, HC /health) → Tasks Fargate.
# SG task só aceita 8000 a partir do SG do ALB (não mais 0.0.0.0/0 na app).

resource "aws_security_group" "alb" {
  name        = "${local.project_name}-alb-sg"
  description = "Lab SG - HTTP 80 to ALB from allowed_cidr"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "HTTP from clients (lab)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    description = "To tasks / internet as needed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-alb-sg"
  }
}

resource "aws_security_group" "task" {
  name        = "${local.project_name}-task-sg"
  description = "Lab SG - HTTP ${local.container_port} only from ALB SG"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description     = "From ALB only"
    from_port       = local.container_port
    to_port         = local.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
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

resource "aws_lb" "app" {
  name               = "${local.project_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = {
    Name = "${local.project_name}-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${local.project_name}-tg"
  port        = local.container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.lab.id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    # interval/timeout: defaults do provider (documentados no design)
  }

  tags = {
    Name = "${local.project_name}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
