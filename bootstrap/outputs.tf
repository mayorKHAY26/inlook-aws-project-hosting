output "terraform_state_bucket_name" {
  description = "Terraform remote state S3 bucket"
  value       = aws_s3_bucket.inlook_terraform_state.bucket
}

output "terraform_state_bucket_arn" {
  description = "Terraform remote state S3 bucket ARN"
  value       = aws_s3_bucket.inlook_terraform_state.arn
}