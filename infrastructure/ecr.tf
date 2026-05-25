resource "aws_ecr_repository" "inlook_frontend_repo" {
  name                 = "${var.project_name}-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-frontend-ecr"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "inlook_backend_repo" {
  name                 = "${var.project_name}-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-backend-ecr"
    Project     = "Inlook"
    Environment = var.environment
  }
}