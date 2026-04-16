# Stage 1 — build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./

# ci instead of install — faster, reproducible, fails on lockfile mismatch
RUN npm ci
COPY . .
RUN npm run build

# Stage 2 — serve (~25MB final image)
FROM nginx:1.27-alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Fix permissions for non-root user
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid

USER nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]