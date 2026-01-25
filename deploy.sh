#!/bin/bash
set -e
echo "Starting Deployment . . .-"
docker-compose pull
docker-compose up -d
docker image prune -f

echo "Deployment successful, Access the app at http://localhost"
echo "Backend health check: http://localhost:8000/api/hello/"


