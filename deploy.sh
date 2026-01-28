#!/bin/bash
set -euo pipefail

DEPLOY_DIR="/home/ubuntu/devops-assessment"

echo "Preparing deployment directory..."
mkdir -p "$DEPLOY_DIR"
chown ubuntu:ubuntu "$DEPLOY_DIR"

echo "Creating .env file..."
cat > "$DEPLOY_DIR/.env" <<EOF
DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}
DJANGO_DEBUG=${DJANGO_DEBUG}
DJANGO_ALLOWED_HOSTS=${DJANGO_ALLOWED_HOSTS}
EOF

echo "Logging into GitHub Container Registry..."
if ! echo "${GHCR_TOKEN}" | docker login ghcr.io -u sohanlal33 --password-stdin; then
    echo "Docker login failed"
    exit 1
fi

echo "Pulling latest Docker images..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" pull

echo "Starting services with docker-compose..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" up -d

echo "Waiting for services to stabilize..."
sleep 15

echo "Running health checks..."
if curl -sf http://localhost >/dev/null && curl -sf http://localhost:8000/api/hello/ >/dev/null; then
    echo "Deployment successful"
else
    echo "Health check failed"
    exit 1
fi

