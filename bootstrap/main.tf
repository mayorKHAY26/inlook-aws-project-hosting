terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "inlook_terraform_state" {
  bucket        = "${var.project_name}-${var.environment}-terraform-state"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-terraform-state"
    Project     = "Inlook"
    Environment = var.environment
    Purpose     = "Terraform Remote State"
  }
}

resource "aws_s3_bucket_versioning" "inlook_state_versioning" {
  bucket = aws_s3_bucket.inlook_terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "inlook_state_encryption" {
  bucket = aws_s3_bucket.inlook_terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "inlook_state_public_block" {
  bucket = aws_s3_bucket.inlook_terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}