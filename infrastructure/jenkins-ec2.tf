data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "tls_private_key" "inlook_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "inlook_key_pair" {
  key_name   = "${var.project_name}-jenkins-key"
  public_key = tls_private_key.inlook_key.public_key_openssh
}

resource "local_file" "inlook_private_key" {
  content         = tls_private_key.inlook_key.private_key_pem
  filename        = "${path.module}/${var.project_name}-jenkins-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "inlook_jenkins" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.jenkins_instance_type
  subnet_id                   = aws_subnet.inlook_public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.inlook_jenkins_sg.id]
  key_name                    = aws_key_pair.inlook_key_pair.key_name
  iam_instance_profile        = aws_iam_instance_profile.inlook_jenkins_instance_profile.name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y openjdk-17-jdk docker.io git unzip curl

              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu

              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
              /usr/share/keyrings/jenkins-keyring.asc > /dev/null

              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
              https://pkg.jenkins.io/debian-stable binary/ | tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null

              apt-get update -y
              apt-get install -y jenkins

              systemctl start jenkins
              systemctl enable jenkins

              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install
              EOF

  tags = {
    Name        = "${var.project_name}-jenkins-server"
    Project     = "Inlook"
    Environment = var.environment
  }
}