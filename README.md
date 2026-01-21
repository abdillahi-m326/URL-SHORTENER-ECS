# Production-Grade URL Shortener Deployment on AWS ECS Fargate

Production-style deployment of a **URL Shortener API** on **AWS ECS Fargate**, provisioned using **Terraform**.  
This project demonstrates **real-world DevOps, Cloud, and Platform Engineering practices**, including modular Infrastructure as Code, environment separation, secure networking, load balancing, WAF protection, and **blue/green deployments with CodeDeploy**.

> **Note:** This repository is intended as a **portfolio and learning project**. Infrastructure is created temporarily for validation and then destroyed to minimize cost.

---

## 🏗️ Infrastructure Highlights

- Modular Terraform architecture with reusable modules  
- Environment-based deployments (`dev` and `prod`)  
- Remote Terraform state using S3 backend with DynamoDB locking  
- Dockerized API deployed on ECS Fargate  
- Application Load Balancer (ALB)  
- AWS WAF v2 protecting the ALB  
- Blue/Green deployments using AWS CodeDeploy (prod)  
- HTTPS with ACM + Route53 (prod)  
- Least-privilege IAM roles  
- CI/CD-ready repository structure  

---

## 🧭 Architecture Overview

### High-Level Request Flow

**Dev**
```
User → ALB (HTTP) → ECS Service → Fargate Task → URL Shortener API
```

**Prod**
```
User → Route53 → ALB (HTTPS)
     → WAF
     → CodeDeploy Blue/Green Target Groups
     → ECS Service (Fargate)
     → URL Shortener API
```

---

## 📊 What This Project Demonstrates

| Domain | Implementation |
|------|---------------|
| Infrastructure as Code | Modular Terraform, remote backend, env separation |
| Container Orchestration | ECS Fargate, task definitions, health checks |
| Networking & Security | VPC, public/private subnets, security groups, IAM |
| Traffic Management | ALB, target groups, blue/green deployments |
| Security | AWS WAF, HTTPS via ACM, least-privilege IAM |
| DevOps Practices | CI/CD-ready structure, safe deploy/destroy |
| Cloud Architecture | Stateless services, managed infrastructure |

---

## 📁 Project Structure

```
.
├── app/
├── terraform/
│   ├── bootstrap/
│   ├── envs/
│   │   ├── dev/
│   │   └── prod/
│   └── modules/
│       ├── vpc/
│       ├── alb/
│       ├── ecs/
│       ├── iam/
│       ├── targetgroup/
│       ├── securitygroup/
│       ├── waf/
│       ├── acm/
│       ├── route53/
│       └── codedeploy/
└── README.md
```

---

## 🧱 Terraform Bootstrapping (One-Time)

```bash
cd terraform/bootstrap
terraform init
terraform apply \
  -var="state_bucket_name=<yourname>-urlshortener-tfstate-2026" \
  -var="lock_table_name=<yourname>-urlshortener-tf-locks" \
  -var="aws_region=us-east-1"
```

---

## ☁️ Deploy Environments

### Dev
```bash
cd terraform/envs/dev
terraform init
terraform apply -var-file=terraform.tfvars
```

### Prod
```bash
cd terraform/envs/prod
terraform init
terraform apply -var-file=terraform.tfvars
```

---

## 🧹 Destroy Infrastructure

```bash
terraform destroy -var-file=terraform.tfvars
```

---

