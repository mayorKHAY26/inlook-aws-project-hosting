resource "aws_guardduty_detector" "inlook_guardduty" {
  enable = true

  tags = {
    Name        = "${var.project_name}-guardduty"
    Project     = "Inlook"
    Environment = var.environment
  }
}