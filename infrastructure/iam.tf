resource "aws_iam_role" "inlook_jenkins_role" {
  name = "${var.project_name}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-jenkins-role"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "inlook_jenkins_ecr_policy" {
  role       = aws_iam_role.inlook_jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "inlook_jenkins_cloudwatch_policy" {
  role       = aws_iam_role.inlook_jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "inlook_jenkins_instance_profile" {
  name = "${var.project_name}-jenkins-instance-profile"
  role = aws_iam_role.inlook_jenkins_role.name
}

resource "aws_iam_role_policy_attachment" "inlook_jenkins_ecs_policy" {
  role       = aws_iam_role.inlook_jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}