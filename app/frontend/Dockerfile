# Stage 1: Build
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Runtime
FROM nginx:alpine

# 1. Create ALL required directories with correct permissions
RUN mkdir -p /tmp/nginx /var/cache/nginx /var/run/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d /tmp/nginx /var/cache/nginx /var/run/nginx /var/log/nginx && \
    chmod -R 755 /tmp/nginx /var/cache/nginx /var/run/nginx

# 2. Replace the entire nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# 3. Remove default config
RUN rm -f /etc/nginx/conf.d/default.conf

# 4. Copy application files
COPY --from=build --chown=nginx:nginx /app/build /usr/share/nginx/html
COPY --chown=nginx:nginx server.conf /etc/nginx/server.conf.template

# 5. Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 6. Switch to nginx user
USER nginx

# Expose port 8080 (HTTP)
EXPOSE 8080

# Start nginx via entrypoint script
ENTRYPOINT ["/entrypoint.sh"]