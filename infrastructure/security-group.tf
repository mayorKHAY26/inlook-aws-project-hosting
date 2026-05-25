resource "aws_security_group" "inlook_jenkins_sg" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Security group for Inlook Jenkins server"
  vpc_id      = aws_vpc.inlook_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Jenkins UI from my IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Grafana from my IP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Prometheus from my IP"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Backend API from my IP"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP frontend public access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS public access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-jenkins-security-group"
    Project     = "Inlook"
    Environment = var.environment
  }
}