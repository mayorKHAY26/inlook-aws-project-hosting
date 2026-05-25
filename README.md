# Inlook — AWS DevOps Webmail Portal Project

## Project Overview

**Inlook** is a cloud-hosted webmail-style application inspired by the Outlook user experience.

The purpose of this project is to demonstrate real-world **AWS Cloud Engineering, DevOps, Infrastructure as Code, CI/CD automation, monitoring, and security engineering** skills by building and deploying a full-stack application in AWS.

Users can:

- Create an account
- Log in securely
- Access a simple inbox dashboard
- Log out
- Interact with a hosted web application

This project simulates how a production web application is deployed, secured, monitored, and automated in AWS.

---

# Project Objectives

This project demonstrates practical implementation of:

- AWS Infrastructure provisioning with Terraform
- CI/CD pipeline automation with Jenkins
- Containerization with Docker
- Container registry management with Amazon ECR
- Monitoring with CloudWatch
- Threat detection with Amazon GuardDuty
- Security posture monitoring with AWS Security Hub
- Application observability with Prometheus
- Dashboard visualization with Grafana
- Web application hosting on AWS EC2
- Infrastructure security with Security Groups and IAM
- Terraform state management using Amazon S3

---

# Architecture Overview

## High-Level Architecture

```text
User Browser
    │
    ▼
Inlook Frontend (Nginx Docker Container)
    │
    ▼
Inlook Backend API (Node.js Docker Container)
    │
    ▼
Application Data Layer
(Currently placeholder db.js)
(Future RDS PostgreSQL / MySQL)
```

---

## AWS Infrastructure Architecture

```text
GitHub Repository
        │
        ▼
Jenkins EC2 Server
        │
        ▼
Docker Build Pipeline
        │
        ▼
Amazon ECR Repositories
        │
        ▼
Application Deployment
        │
        ▼
AWS Infrastructure
    ├── VPC
    ├── Public Subnets
    ├── Internet Gateway
    ├── Route Tables
    ├── Security Groups
    ├── Jenkins EC2
    ├── CloudWatch
    ├── GuardDuty
    ├── Security Hub
    ├── Prometheus
    └── Grafana
```

---

# Project Directory Structure

```text
inlook-aws-project/
│
├── .gitignore
│
├── bootstrap/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── infrastructure/
│   ├── provider.tf
│   ├── vpc.tf
│   ├── subnet.tf
│   ├── internet-gateway.tf
│   ├── route-table.tf
│   ├── security-group.tf
│   ├── cloudwatch.tf
│   ├── guardduty.tf
│   ├── securityhub.tf
│   ├── iam.tf
│   ├── ecr.tf
│   ├── jenkins-ec2.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── monitoring/
│   ├── prometheus/
│   │   ├── prometheus.yml
│   │   └── alert.rules.yml
│   │
│   └── grafana/
│       ├── docker-compose.yml
│       ├── provisioning/
│       │   ├── datasources/
│       │   │   └── datasource.yml
│       │   │
│       │   └── dashboards/
│       │       └── dashboard.yml
│       │
│       └── dashboards/
│           ├── inlook-system-dashboard.json
│           ├── inlook-application-dashboard.json
│           ├── inlook-docker-dashboard.json
│           └── inlook-security-dashboard.json
│
├── app/
│   ├── frontend/
│   │   ├── index.html
│   │   ├── style.css
│   │   ├── app.js
│   │   ├── Dockerfile
│   │   └── nginx.conf
│   │
│   └── backend/
│       ├── server.js
│       ├── routes.js
│       ├── db.js
│       ├── package.json
│       ├── Dockerfile
│       └── .env
│
├── jenkins/
│   └── Jenkinsfile
│
└── README.md
```

---

# Directory Purpose

## bootstrap/

Contains foundational Terraform resources.

Resources:

- Terraform backend S3 bucket
- Bucket versioning
- Server-side encryption
- Public access blocking

Purpose:

This is created first because Terraform state storage must exist before infrastructure provisioning.

---

## infrastructure/

Contains AWS infrastructure resources.

Resources:

- AWS provider
- VPC
- Public subnets
- Internet gateway
- Route tables
- Security groups
- Jenkins EC2
- IAM roles
- Amazon ECR
- CloudWatch
- GuardDuty
- Security Hub

Purpose:

Core AWS infrastructure deployment.

---

## monitoring/

Contains observability configuration.

Components:

- Prometheus metrics scraping
- Alert rules
- Grafana dashboards
- Grafana datasource provisioning

Purpose:

Application and infrastructure monitoring.

---

## app/

Contains full-stack application code.

Frontend:

- HTML
- CSS
- JavaScript
- Nginx Docker image

Backend:

- Node.js Express API
- authentication routes
- health endpoint
- future database integration

Purpose:

Inlook application source code.

---

## jenkins/

Contains CI/CD automation pipeline.

Purpose:

Automates:

- GitHub checkout
- Docker image builds
- ECR image push
- deployment workflow

---

# Terraform Deployment Order

## Step 1 — Bootstrap

Create Terraform backend resources first.

```bash
cd bootstrap
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

---

## Step 2 — Infrastructure

Deploy AWS infrastructure.

```bash
cd ../infrastructure
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Creates:

- VPC
- subnets
- route tables
- security groups
- Jenkins EC2
- ECR repositories
- CloudWatch
- GuardDuty
- Security Hub

---

# Terraform Destroy Order

Destroy in reverse dependency order.

## Step 1

```bash
cd infrastructure
terraform destroy
```

## Step 2

```bash
cd ../bootstrap
terraform destroy
```

---

# Security Group Ports

| Port | Purpose |
|------|---------|
| 22 | SSH |
| 80 | Frontend HTTP |
| 443 | HTTPS |
| 8080 | Jenkins |
| 5000 | Backend API |
| 3000 | Grafana |
| 9090 | Prometheus |

---

# CI/CD Workflow

```text
Developer Pushes Code
        │
        ▼
GitHub Repository
        │
        ▼
Jenkins Pipeline Trigger
        │
        ▼
Build Frontend Docker Image
        │
        ▼
Build Backend Docker Image
        │
        ▼
Push Images to Amazon ECR
        │
        ▼
Deploy Application
```

---

# Monitoring Stack

## AWS Native Monitoring

### CloudWatch

Used for:

- application logs
- EC2 monitoring
- CPU alarms
- operational visibility

---

### GuardDuty

Used for:

- suspicious API activity
- threat intelligence detection
- account compromise monitoring

---

### Security Hub

Used for:

- centralized security findings
- AWS security best practices
- posture visibility

---

## Application Monitoring

### Prometheus

Used for:

- metrics scraping
- service health monitoring
- alert generation

---

### Grafana

Used for dashboards:

- system dashboard
- application dashboard
- Docker dashboard
- security dashboard

---

# Jenkins Access

After deployment:

Terraform output provides:

```bash
terraform output inlook_jenkins_url
```

Example:

```text
http://44.xx.xx.xx:8080
```

Initial admin password:

SSH into Jenkins:

```bash
ssh -i inlook-jenkins-key.pem ubuntu@<public-ip>
```

Then:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

# Local Application Run

## Backend

```bash
cd app/backend
npm install
npm start
```

Runs on:

```text
http://localhost:5000
```

---

## Frontend

```bash
cd app/frontend
docker build -t inlook-frontend .
docker run -p 8080:80 inlook-frontend
```

Access:

```text
http://localhost:8080
```

---

# Git Security

terraform.tfvars is ignored.

`.gitignore` protects:

- terraform.tfvars
- .env
- Terraform state
- node_modules
- logs
- temporary files

---

# Future Enhancements

Planned upgrades:

- Amazon RDS database
- HTTPS with ACM
- Application Load Balancer
- Route 53 DNS
- ECS deployment
- EKS Kubernetes deployment
- Docker Compose local stack
- real authentication (JWT)
- user sessions
- email attachment uploads to S3
- SES integration
- auto scaling

---

# Interview Summary

This project demonstrates:

- AWS networking
- Terraform Infrastructure as Code
- EC2 provisioning
- IAM permissions
- CI/CD automation
- Docker containerization
- Amazon ECR workflows
- monitoring and alerting
- cloud security engineering
- application deployment architecture

---

# Author

Built as an AWS Cloud Engineering / DevOps portfolio project.