
cd /home/ubuntu/devops-assessment

echo "Creating runtime .env file..."
cat > .env <<EOF
DJANGO_SECRET_KEY=***
DJANGO_DEBUG=***
DJANGO_ALLOWED_HOSTS=***
EOF

ls -l .env

docker-compose pull
docker-compose up -d

sleep 10

curl -f http://localhost || { echo "Frontend health check failed"; exit 1; }
curl -f http://localhost:8000/api/hello/ || { echo "Backend health check failed"; exit 1; }

echo "Deployment completed successfully"

