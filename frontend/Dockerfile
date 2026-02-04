# Ctrl+Shift+Date Frontend Dockerfile
# Flutter Web deployment

# Build stage - Flutter SDK
FROM ghcr.io/cirruslabs/flutter:stable as builder

WORKDIR /app

# Copy pubspec files first for dependency caching
COPY pubspec.yaml pubspec.lock* ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build for web with production optimizations
RUN flutter build web --release --web-renderer html --dart-define=FLUTTER_WEB_USE_SKIA=false

# Production stage - Nginx
FROM nginx:alpine as production

# Remove default nginx config
RUN rm -rf /usr/share/nginx/html/*

# Copy built web app
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Add health check endpoint
RUN echo "OK" > /usr/share/nginx/html/health

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget -q --spider http://localhost/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
