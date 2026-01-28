#!/bin/bash
set -e

# Create .env file from environment variables passed during SSH
cat > /home/ubuntu/devops-assessment/.env <<EOF
DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}
DJANGO_DEBUG=${DJANGO_DEBUG}
DJANGO_ALLOWED_HOSTS=${DJANGO_ALLOWED_HOSTS}
EOF

echo "Logging into GHCR..."
echo "${GHCR_TOKEN}" | docker login ghcr.io -u sohanlal33 --password-stdin

echo "Pulling images..."
docker-compose pull

echo "Starting services..."
docker-compose up -d

echo "Running health checks..."
sleep 10

if curl -sf http://localhost >/dev/null && curl -sf http://localhost:8000/api/hello/ >/dev/null; then
    echo "Deployment successful"
else
    echo "Health check failed"
    exit 1
fi

