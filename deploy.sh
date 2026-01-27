#!/bin/bash
set -e

echo "Check Docker..."
if ! which docker > /dev/null; then
  echo "Docker not found. Please install Docker."
  exit 1
fi

echo "Check if Docker is running..."
if ! systemctl is-active --quiet docker; then
  echo "Docker is not running. Trying to start it..."
  sudo systemctl start docker || { echo "Could not start Docker. Please start it yourself."; exit 1; }
fi

echo "Check Docker Compose..."
if ! which docker-compose > /dev/null && ! docker compose version > /dev/null 2>&1; then
  echo "Docker Compose not found. Please install it."
  exit 1
fi

echo "All checks passed. Deploying now..."

# Docker Hub Login
echo "Logging into Docker Hub..."
if [ -n "$DOCKERHUB_USERNAME" ] && [ -n "$DOCKERHUB_TOKEN" ]; then
    echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
else
    echo "Warning: DockerHub credentials not found. Pull might fail if repository is private."
fi

# Deployment
docker-compose pull
docker-compose up -d
docker image prune -f

echo "Deployment successful, Access the app at http://localhost"
echo "Backend health check: http://localhost:8000/api/hello/"
