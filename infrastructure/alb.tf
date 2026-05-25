resource "aws_security_group" "inlook_alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for Inlook Application Load Balancer"
  vpc_id      = aws_vpc.inlook_vpc.id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_security_group" "inlook_ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Security group for Inlook ECS tasks"
  vpc_id      = aws_vpc.inlook_vpc.id

  ingress {
    description     = "Allow frontend traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.inlook_alb_sg.id]
  }

  ingress {
    description     = "Allow backend traffic from ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.inlook_alb_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-ecs-sg"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_lb" "inlook_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.inlook_alb_sg.id]
  subnets = [
    aws_subnet.inlook_public_subnet_1.id,
    aws_subnet.inlook_public_subnet_2.id
  ]

  tags = {
    Name        = "${var.project_name}-alb"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "inlook_frontend_tg" {
  name        = "${var.project_name}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.inlook_vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.project_name}-frontend-tg"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "inlook_http_listener" {
  load_balancer_arn = aws_lb.inlook_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inlook_frontend_tg.arn
  }
}

resource "aws_lb_target_group" "inlook_backend_tg" {
  name        = "${var.project_name}-backend-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.inlook_vpc.id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.project_name}-backend-tg"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_lb_listener_rule" "inlook_register_rule" {
  listener_arn = aws_lb_listener.inlook_http_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inlook_backend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/register"]
    }
  }
}

resource "aws_lb_listener_rule" "inlook_login_rule" {
  listener_arn = aws_lb_listener.inlook_http_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inlook_backend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/login"]
    }
  }
}

resource "aws_lb_listener_rule" "inlook_health_rule" {
  listener_arn = aws_lb_listener.inlook_http_listener.arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inlook_backend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/health"]
    }
  }
}