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
    chown -R nginx:nginx /tmp/nginx /var/cache/nginx /var/run/nginx /var/log/nginx && \
    chmod -R 755 /tmp/nginx /var/cache/nginx /var/run/nginx

# 2. Replace the entire nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# 3. Remove default config
RUN rm -f /etc/nginx/conf.d/default.conf

# 4. Copy application files
COPY --from=build --chown=nginx:nginx /app/build /usr/share/nginx/html
COPY --chown=nginx:nginx server.conf /etc/nginx/conf.d/

# 5. Switch to nginx user
USER nginx

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]