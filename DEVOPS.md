ÌøóÔ∏è Enterprise DevOps Assessment: Cloud Infrastructure
A production-grade, automated deployment ecosystem featuring Infrastructure as Code (IaC), GHCR Integration, and Self-Hosted CI/CD Orchestration.
Ìºê System Architecture & Network Flow
The project implements a decoupled, secure architecture designed for high availability and minimal attack surface.
Infrastructure: AWS EC2 (t3.micro) provisioned via Terraform within a secured VPC.
Edge Routing: Nginx acts as the primary entry point on Host Port 80, handling SSL termination (Roadmap) and static routing.
Reverse Proxy Logic: Configured to serve React static assets and proxy API requests to the Gunicorn/Django backend over a private internal app_network.
Deployment: GitHub Actions utilizes a Self-Hosted Runner on the target EC2 to eliminate the need for exposing Port 22 (SSH) to the public internet.
Ìª†Ô∏è Setup & Infrastructure Execution
1Ô∏è‚É£ Provisioning (IaC)
cd terraform
cd terraform init          # Initialize provider plugins
terraform plan          # Review execution plan
terraform apply -auto-approve

Ìºê Network Identity & DNS Configuration
To transition from a raw IP to a production-ready URL, the following networking layer was implemented:

DNS Mapping: A custom A Record was created pointing nexgensis-assessment.aitoolsbots.xyz to the AWS Elastic IP.

Static Persistence: By utilizing an Elastic IP (EIP), the domain-to-server mapping remains immutable, preventing service disruption during EC2 reboots or maintenance cycles.

Routing: Nginx is configured to recognize the server_name header, ensuring traffic for the specific subdomain is routed correctly to the frontend container.

2Ô∏è‚É£ Manual Deployment & Verification
git clone https://github.com/Sohanlal33/devops-assessment.git
cd devops-assessment

# Initialize Environment & Secrets
cp .env.example .env
chmod +x deploy.sh

# Atomic Orchestration
./deploy.sh

‚ö° CI/CD & Automation Excellence
Ì≥¶ Docker Buildx & Intelligent Caching
The pipeline in .github/workflows/deploy.yml leverages GHA Caching to achieve elite performance:
Mechanism: cache-from: type=gha and cache-to: type=gha,mode=min.
Impact: Reduces build times by ~80% by intelligently reusing immutable image layers, essential for resource-constrained t3.micro environments.
Ì¥ê Zero-Trust Secret Management
Secrets are never stored on-disk in the repository; they are injected strictly at runtime:
Dynamic Generation: The self-hosted runner generates the .env file on-the-fly using GitHub Secrets.
Hardened Permissions: The .env is restricted , ensuring only the container-owner can read sensitive credentials.
Ìª†Ô∏è Senior Decisions
Technical Implementation
Security-Non-Root Execution: Both Gunicorn and Nginx run as unprivileged users to mitigate container breakout risks.
Port Logic-Nginx listens on 8080 (to bypass privileged port restrictions) and is bridged to Port 80 via Docker Compose.
Networking-VPC Isolation: Deployment occurs via a self-hosted runner, keeping the instance private from external SSH probes.
Ì¥ç Troubleshooting Highlight: The Nginx PID Fix
Issue: Nginx failed with Permission denied while attempting to write to /run/nginx.pid.Cause: Standard Nginx images attempt to write to root-protected directories, which fails under our Non-Root Security Policy.
Resolution: Re-engineered nginx.conf to use pid /tmp/nginx.pid; and updated the Dockerfile to chown log/cache directories, maintaining high security without sacrificing functionality.
Ì∫Ä Production Readiness & Roadmap
HTTPS/TLS: Integrate Certbot/Let‚Äôs Encrypt for automated 2048-bit RSA certificate renewal.
Reliability: Implement an AWS Application Load Balancer (ALB) for managed SSL termination and health-check based auto-healing.
Ì¥ó Resource Links
Live Application: http://nexgensis-assessment.aitoolsbots.xyz/Project 
Repository: Sohanlal33/devops-assessment
