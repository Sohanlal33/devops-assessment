# 🏗️ Enterprise DevOps Assessment: Cloud Infrastructure

A production-grade, automated deployment ecosystem leveraging Infrastructure as Code (IaC), GitHub Container Registry (GHCR), and a self-hosted CI/CD execution model.

---

## 🌐 System Architecture & Network Flow

The solution implements a decoupled and security-conscious architecture designed for high availability, operational clarity, and a minimal attack surface.

- **Infrastructure:** AWS EC2 (t3.micro) provisioned using Terraform within a secured VPC.
- **Edge Routing:** Nginx operates as the primary entry point on Host Port 80, handling static routing and reverse proxy responsibilities.
- **Reverse Proxy Logic:** Nginx serves React static assets and proxies API requests to the Django backend running on Gunicorn over a private Docker bridge network (`app_network`).
- **Deployment Model:** GitHub Actions executes via a self-hosted runner on the target EC2 instance, eliminating the need to expose SSH (Port 22) to the public internet.

---

## 🛠️ Setup & Infrastructure Execution

### 1️⃣ Infrastructure Provisioning (IaC)

```bash
cd terraform
terraform init          # Initialize provider plugins
terraform plan          # Review execution plan
terraform apply -auto-approve

🌐 Network Identity & DNS Configuration

To transition from a raw IP address to a production-ready domain, the following networking strategy was implemented:

DNS Mapping: A custom A record maps nexgensis-assessment.aitoolsbots.xyz to an AWS Elastic IP.

Static Persistence: Elastic IP ensures the domain remains stable across EC2 restarts and maintenance cycles.

Routing Control: Nginx is configured with an explicit server_name directive to route domain-specific traffic correctly to the frontend container.

🚀 Manual Deployment & Verification (Non-CI)
git clone https://github.com/Sohanlal33/devops-assessment.git
cd devops-assessment

#ensure ubuntu:ubuntu user
chmod +x deploy.sh
./deploy.sh

Note: Runtime secrets are injected dynamically during CI/CD execution. No .env.example files are copied or committed.

⚡ CI/CD & Automation Excellence
📦 Docker Buildx & Intelligent Caching

The GitHub Actions pipeline (.github/workflows/deploy.yml) utilizes Buildx with GitHub Actions cache:

Mechanism:
cache-from: type=gha
cache-to: type=gha,mode=min

Impact:
Significantly reduces build time by reusing immutable image layers, critical for resource-constrained environments such as t3.micro instances.

🔐 Zero-Trust Secret Management

Secrets are never committed or stored on disk.

GitHub Secrets are injected at runtime during deployment.

The self-hosted runner dynamically generates the .env file with restricted permissions, ensuring only the container runtime can access sensitive values.

🧠 Key Engineering Decisions

Non-Root Execution: Both Gunicorn and Nginx run as unprivileged users to mitigate container escape risks.

Port Strategy: Nginx listens on port 8080 internally to avoid privileged port execution and is mapped to port 80 via Docker Compose.

Network Isolation: CI/CD execution via a self-hosted runner avoids exposing SSH access, reducing the external attack surface.

🔍 Troubleshooting Highlight: Nginx PID Handling

Issue: Nginx failed with Permission denied when attempting to write to /run/nginx.pid.

Root Cause: Default Nginx images expect root-level write access, incompatible with non-root execution.

Resolution:

Updated nginx.conf to use pid /tmp/nginx.pid

Adjusted Dockerfile to apply correct ownership on log and cache directories
This preserved security posture without sacrificing stability.

🧩 System Architecture Diagram
flowchart LR
    Developer -->|git push| GitHub
    GitHub -->|GitHub Actions| Runner[Self-Hosted Runner]
    Runner -->|Docker Buildx| GHCR[(GitHub Container Registry)]
    Runner -->|docker-compose| EC2[AWS EC2 Instance]

    EC2 --> Nginx
    Nginx --> Frontend[React Container]
    Nginx --> Backend[Django + Gunicorn]

📈 Production Readiness & Roadmap

HTTPS/TLS: Integrate Let’s Encrypt or ACM for automated certificate management.

Reliability: Introduce AWS Application Load Balancer (ALB) for managed SSL termination and health checks.

Scalability: Migrate workloads to ECS Fargate and persistent storage to Amazon RDS for Multi-AZ resilience.

🔗 Resource Links

Live Application: http://nexgensis-assessment.aitoolsbots.xyz

Source Repository: https://github.com/Sohanlal33/devops-assessment


---
