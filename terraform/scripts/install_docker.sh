#!/bin/bash
set -e

echo "Installing Docker (Ubuntu LTS safe) and Docker Compose v1..."

# Ensure root
if [ "$EUID" -ne 0 ]; then
  echo "Run as root (sudo)"
  exit 1
fi

# Update system
apt-get update -y

# Install Docker
apt-get install -y docker.io curl

systemctl start docker
systemctl enable docker

# Allow ubuntu user to run docker
usermod -aG docker ubuntu || true

if ! command -v docker-compose >/dev/null 2>&1; then
  echo "Installing docker-compose v1..."
  curl -L \
    "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose

  chmod +x /usr/local/bin/docker-compose
else
  echo "docker-compose already installed"
fi

# Verify
docker --version
docker-compose --version

echo "Docker and Docker Compose installation completed"

