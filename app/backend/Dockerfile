FROM node:18-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S demo && adduser -S demo -G demo

# Copy package files first for better layer caching
COPY --chown=demo:demo package.json package-lock.json ./

# Install production deps (no devDependencies)
RUN npm ci --only=production \
    && npm cache clean --force

# Copy app source (with correct permissions)
COPY --chown=demo:demo src ./src

USER demo

EXPOSE 3000
CMD ["npm", "start"]