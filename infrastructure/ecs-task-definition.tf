resource "aws_iam_role" "inlook_ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-ecs-task-execution-role"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "inlook_ecs_task_execution_policy" {
  role       = aws_iam_role.inlook_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "inlook_ecs_logs" {
  name              = "/ecs/inlook"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-ecs-logs"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "inlook_task" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.inlook_ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "inlook-frontend"
      image     = "${aws_ecr_repository.inlook_frontend_repo.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.inlook_ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "frontend"
        }
      }
    },
    {
      name      = "inlook-backend"
      image     = "${aws_ecr_repository.inlook_backend_repo.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "PORT"
          value = "5000"
        },
        {
          name  = "APP_NAME"
          value = "Inlook"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.inlook_ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.project_name}-task-definition"
    Project     = "Inlook"
    Environment = var.environment
  }
}