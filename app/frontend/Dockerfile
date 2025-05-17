# Stage 1: Build
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Runtime
FROM nginx:alpine

# Create required directories and set permissions for rootless Nginx
RUN mkdir -p /tmp/nginx /var/cache/nginx /var/run/nginx /var/log/nginx \
    && chown -R nginx:nginx /etc/nginx/conf.d /tmp/nginx /var/cache/nginx /var/run/nginx /var/log/nginx /usr/share/nginx/html \
    && chmod -R 755 /tmp/nginx /var/cache/nginx /var/run/nginx

# Copy Nginx config and backend template
COPY nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx backend.conf.template /tmp/backend.conf.template

# Copy application files 
COPY --from=build --chown=nginx:nginx /app/build /usr/share/nginx/html

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to nginx user for rootless operation
USER nginx

# Expose port 8080 (HTTP)
EXPOSE 8080

# Start nginx via entrypoint script
ENTRYPOINT ["/entrypoint.sh"]