variable "aws_region" {
  description = "AWS region for Inlook infrastructure"
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

variable "vpc_cidr" {
  description = "CIDR block for Inlook VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "my_ip" {
  description = "Your public IP address with /32 for SSH, Jenkins, Grafana, Prometheus"
  type        = string
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
  default     = "t3.medium"
}