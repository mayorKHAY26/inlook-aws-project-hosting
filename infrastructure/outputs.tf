output "inlook_vpc_id" {
  value = aws_vpc.inlook_vpc.id
}

output "inlook_public_subnet_1_id" {
  value = aws_subnet.inlook_public_subnet_1.id
}

output "inlook_public_subnet_2_id" {
  value = aws_subnet.inlook_public_subnet_2.id
}

output "inlook_jenkins_public_ip" {
  value = aws_instance.inlook_jenkins.public_ip
}

output "inlook_jenkins_url" {
  value = "http://${aws_instance.inlook_jenkins.public_ip}:8080"
}

output "inlook_jenkins_ssh_command" {
  value = "ssh -i ${var.project_name}-jenkins-key.pem ubuntu@${aws_instance.inlook_jenkins.public_ip}"
}

output "inlook_frontend_ecr_url" {
  value = aws_ecr_repository.inlook_frontend_repo.repository_url
}

output "inlook_backend_ecr_url" {
  value = aws_ecr_repository.inlook_backend_repo.repository_url
}

output "inlook_cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.inlook_application_logs.name
}

output "inlook_guardduty_detector_id" {
  value = aws_guardduty_detector.inlook_guardduty.id
}

output "inlook_app_url" {
  description = "Public URL for the Inlook application"
  value       = "http://${aws_lb.inlook_alb.dns_name}"
}

output "inlook_ecs_cluster_name" {
  description = "Inlook ECS cluster name"
  value       = aws_ecs_cluster.inlook_cluster.name
}

output "inlook_ecs_service_name" {
  description = "Inlook ECS service name"
  value       = aws_ecs_service.inlook_service.name
}