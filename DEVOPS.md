# DEVOPS.md

# DevOps Assignment Documentation

---

## 1. Setup Guide

### Prerequisites
- Docker and Docker Compose installed on your machine.
- Git installed.
- Access to Docker Hub account (for pulling/pushing images).
- (Optional) Access to cloud provider for deployment (AWS/Azure/GCP).

### Running Locally

1. Clone the repository:
   git clone https://github.com/Sohanlal33/devops-assessment.git
   cd devops-assessment


2. Create a `.env` file in the root directory based on `.env.example` with environment variables.
   DJANGO_SECRET_KEY=your_secret_key_here,
   DJANGO_DEBUG=FALSE,
   DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,

3. Build and run containers locally using Docker Compose:
   Run the deployment script to automate update and start containers:
   - Verify Registry Access: Ensure you are logged into your Docker Hub account: 
     docker login
   - Execute Deployment Script: The deploy.sh script automates image pulling, container orchestration, and system cleanup:
     chmod +x deploy.sh
     ./deploy.sh
   - Verify Service Health: Once the script completes, verify that both the Frontend and Backend services are running:
     docker ps          

   The script will:
   - Pull the latest Docker images.
   - Start the backend and frontend services.
   - Clean up unused Docker images.
      
4. Access the application:
- Frontend: http://localhost
- Backend API: http://localhost:8000/api/hello/

  Stop Environment:
  - Docker compose down

---

### Running on Server

- SSH into your server.
- Pull the repository.
- Ensure Docker and Docker Compose are installed.

---

## Infrastructure Provisioning and Automated Deployment

Terraform is used to provision the cloud infrastructure, and a bootstrap script is used to prepare the EC2 instance for containerized deployment.

### Provision Infrastructure (Terraform)
```bash
cd terraform
terraform init
terraform apply

The install_docker.sh script installs and configures Docker on the instance.
The deploy.sh script pulls images and deploys services using Docker Compose.
CI/CD validation is handled through GitHub Actions on every push to the main branch.

Using Self-Hosted Runner for CI/CD:
  To improve deployment reliability and reduce external dependencies, a self-hosted GitHub Actions runner is configured on the AWS EC2 instance. This runner:
  Executes the CI/CD workflow directly within the deployment environment.
  Enables seamless orchestration with the deployed Docker environment.
  Avoids SSH key transfer complexities by running workflows locally on the server.
  Setup steps:
  Register the GitHub Actions runner on the EC2 instance following GitHub's official instructions
  The workflow file (.github/workflows/deploy.yml) is configured with runs-on: self-hosted to utilize this runner.
  Deployment and orchestration commands are executed locally, simplifying environment variable management and Docker Compose usage.   

Instance Setup and Application Deployment:
 - ssh -i <key>.pem ec2-user@<elastic-ip>
 - git clone https://github.com/Sohanlal33/devops-assessment.git

  - Application will be accessible on the configured ports.

  Deployment Environment: AWS EC2
  The application is deployed on an AWS EC2 instance provisioned via Terraform.
  Docker and Docker Compose are installed and configured automatically during instance bootstrap.
  Docker images are pulled from GitHub Container Registry (GHCR) and orchestrated using Docker Compose on the EC2 host.
  The EC2 instance serves both backend and frontend services on configured ports.
  The deployment script (deploy.sh) is executed on the EC2 instance either manually or automatically via GitHub Actions.
---

## 2. Troubleshooting Log

### Challenge: Nginx Permission Denied on PID File

- **Issue:** Nginx failed to start inside the frontend container with `open() "/run/nginx.pid" failed (13: Permission denied)`.
- **Cause:** Nginx was running as a non-root user but lacked permissions for necessary directories.
- **Solution:**
- Created a dedicated non-root user and group in the Dockerfile.
- Changed ownership of critical directories (`/var/cache/nginx`, `/var/log/nginx`, `/etc/nginx/conf.d`, and the pid file location) to the non-root user.
- Adjusted Nginx to use a PID file in `/tmp` with correct permissions.

---

## 3. Additional Notes

- **Security Best Practices:**
- Multi-stage Docker builds reduce image size and attack surface.
- Applications run as non-root users.
- No secrets or API keys are hardcoded; environment variables are used.

- **Automation:**
- GitHub Actions workflow builds and pushes Docker images on every push to the main branch.
- Deployment automation via a shell script (`deploy.sh`) for local/self-hosted deployment.
- - The GitHub Actions CI/CD pipeline has been thoroughly tested to build, push, and deploy images on every fresh push to the main branch, ensuring continuous delivery and integration.
  - The CI/CD pipeline utilizes a self-hosted GitHub Actions runner on AWS EC2 for direct deployment, enhancing security by minimizing exposure of secrets and SSH keys.
  - The approach ensures faster feedback loops and avoids common SSH connectivity issues.
  - Terraform automates infrastructure provisioning, while shell scripts automate Docker environment setup and container lifecycle management.

- **Documentation:**
- This file provides clear instructions to run and troubleshoot.
- `.env.example` provided for environment configuration reference.

---

## Submission Checklist

- Application source code with frontend and backend directories.
- Dockerfiles for frontend and backend with multi-stage builds.
- `docker-compose.yml` orchestrating both services with proper networking and health checks.
- GitHub Actions workflow in `.github/workflows/`.
- Terraform files.
- Deployed URL (if deployed to cloud).
- Screenshot of the running application in production/local environment.
- `DEVOPS.md` with setup and troubleshooting details.
- `deploy.sh` script automating container deployment.

---

**Repository:** https://github.com/Sohanlal33/devops-assessment.git

---

