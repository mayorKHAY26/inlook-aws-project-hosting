resource "aws_ecs_cluster" "inlook_cluster" {
  name = "${var.project_name}-ecs-cluster"

  tags = {
    Name        = "${var.project_name}-ecs-cluster"
    Project     = "Inlook"
    Environment = var.environment
  }
}