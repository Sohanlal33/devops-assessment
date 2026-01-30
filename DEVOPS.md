Enterprise DevOps Assessment: Full-Stack Cloud Infrastructure
A production-grade, automated deployment ecosystem featuring Infrastructure as Code (IaC), GHCR Integration, and Self-Hosted CI/CD Orchestration.

Ìøó System Architecture & Network Flow
The project implements a decoupled, secure architecture designed for high availability:

Infrastructure: AWS EC2 (t3.micro) provisioned via Terraform within the Default VPC.

Edge Routing: Nginx acts as the primary entry point on Host Port 80.

Reverse Proxy Logic: Nginx is configured to serve React static files and can proxy requests to the Gunicorn backend over the internal app_network.

Deployment: GitHub Actions utilizes a Self-Hosted Runner on the target EC2 to eliminate external SSH dependencies.

1. Setup & Infrastructure Creation
Ì≥ã Prerequisites & Permissions
Before deployment, the environment must be prepared to allow the ubuntu user to manage Docker and the repository:

Add User to Docker Group: sudo usermod -aG docker ubuntu (Requires a re-log to apply).

Directory Ownership: Ensure the deployment path is owned by the runner user: sudo chown -R ubuntu:ubuntu /home/ubuntu/devops-assessment.

ÌøóÔ∏è Step 1: Provision Infrastructure (IaC)

cd terraform
terraform init             # Initialize provider plugins
terraform plan             # Review infrastructure execution plan
terraform apply -auto-approve # Provision EC2, Security Groups, and Elastic IP
Ì≤ª Step 2: Local Run & Verification
Initialize: ```bash git clone https://www.google.com/search?q=https://github.com/Sohanlal33/devops-assessment.git sudo chown -R $USER:$USER devops-assessment cd devops-assessment

Environment: cp .env.example .env

Deploy:

Bash
chmod +x deploy.sh
./deploy.sh
2. CI/CD & Automation Excellence
‚ö° Docker Buildx & Caching
The pipeline in .github/workflows/deploy.yml utilizes GHA Cache:

Mechanism: cache-from: type=gha and cache-to: type=gha,mode=max.

Benefit: Reduces deployment cycles by up to 80% by reusing unchanged image layers.

Ì¥ê Zero-Trust Secret Management
Secrets are injected strictly at runtime to prevent exposure:

Runtime Generation: The self-hosted runner dynamically generates the .env file on the EC2 instance during deployment using a cat <<EOF block.

Persistence: The .env file is scoped to the runner's permission level (600) to prevent unauthorized access on the host.

3. Engineering Decisions
Ìª°Ô∏è Security Hardening & Networking
Non-Root Execution: Both Django (Gunicorn) and React (Nginx) run as non-privileged users.

Port Mapping Logic: Since non-root users cannot bind to Port 80, Nginx listens on 8080.

Host Bridge: The docker-compose.yml maps 80:8080. This allows public HTTP access while the container process remains restricted.

Backend Access: The backend is exposed on :8000 for testing, but in a full production setup, all traffic is unified through the Nginx reverse proxy.

Ì¥ç Troubleshooting Log
Issue: Nginx Permission Denied on PID File (open() "/run/nginx.pid" failed (13: Permission denied)). Cause: Nginx attempted to write its PID to a root-owned directory while running as a non-root user. Resolution:

Modified nginx.conf to use pid /tmp/nginx.pid;.

Updated Dockerfile to chown cache and log directories to the nginx user.

4. Production Readiness & Roadmap
Automated Provisioning: Utilize Certbot with Let‚Äôs Encrypt to issue and auto-renew 2048-bit RSA certificates, integrating them directly into the Nginx configuration.

Managed Scalability: For enterprise reliability, move to AWS Certificate Manager (ACM) paired with an Application Load Balancer (ALB) to offload SSL decryption from the EC2 instance, improving overall system performance.

Resource                  Access Link
Live Application	http://nexgensis-assessment.aitoolsbots.xyz/
Project Repository	Sohanlal33/devops-assessment
