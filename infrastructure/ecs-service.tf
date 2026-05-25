resource "aws_ecs_service" "inlook_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.inlook_cluster.id
  task_definition = aws_ecs_task_definition.inlook_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.inlook_public_subnet_1.id,
      aws_subnet.inlook_public_subnet_2.id
    ]

    security_groups  = [aws_security_group.inlook_ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.inlook_frontend_tg.arn
    container_name   = "inlook-frontend"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.inlook_http_listener,
    aws_iam_role_policy_attachment.inlook_ecs_task_execution_policy
  ]

  tags = {
    Name        = "${var.project_name}-ecs-service"
    Project     = "Inlook"
    Environment = var.environment
  }
}