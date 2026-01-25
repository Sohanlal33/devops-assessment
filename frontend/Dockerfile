FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps
COPY . .
RUN npm run build

FROM nginx:stable-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Fix: Overwrite the master config to remove the "unknown directive" error
RUN echo 'events { worker_connections 1024; } http { include /etc/nginx/mime.types; include /etc/nginx/conf.d/*.conf; }' > /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Setup permissions for non-root user
RUN touch /tmp/nginx.pid && \
    chown -R appuser:appgroup /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /tmp/nginx.pid

# Verify if your React build folder is 'dist' (Vite) or 'build' (CRA)
COPY --from=builder /app/dist /usr/share/nginx/html
RUN chown -R appuser:appgroup /usr/share/nginx/html

USER appuser
EXPOSE 8080

# JSON format to satisfy the warning and handle signals correctly
CMD ["nginx", "-g", "daemon off; pid /tmp/nginx.pid;"]
