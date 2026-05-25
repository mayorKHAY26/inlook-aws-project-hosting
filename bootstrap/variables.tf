variable "aws_region" {
  description = "AWS region for bootstrap resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "inlook"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}