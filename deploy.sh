#!/bin/bash

cd /home/ubuntu/devops-assessment

echo "Pulling latest images..."
docker-compose pull

echo "Starting services..."
docker-compose up -d

echo "Waiting for services to stabilize..."
sleep 10

curl -f http://localhost || { echo "Frontend health check failed"; exit 1; }
curl -f http://localhost:8000/api/hello/ || { echo "Backend health check failed"; exit 1; }

echo "Deployment successful"

