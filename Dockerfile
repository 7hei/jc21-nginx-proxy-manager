# Use the official jc21/nginx-proxy-manager image as the base
FROM docker.io/jc21/nginx-proxy-manager:latest

# Set environment variables (optional)
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system packages to the latest version
RUN apt-get update && apt-get upgrade -y

# Optionally, install additional packages (e.g., tools or dependencies)
RUN apt-get install -y nano

# Clean up unnecessary files to reduce the image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Remove dev.conf, not required for Production environment
RUN rm -f /etc/nginx/conf.d/dev.conf

# Modify the Nginx Proxy Manager config to listen on port 9020 instead of 81
RUN sed -i 's#81 default;#9020 default;#g' /etc/nginx/conf.d/production.conf
RUN sed -i 's#:81 default;#:9020 default;#g' /etc/nginx/conf.d/production.conf

# Customize logging
RUN sed -i 's#access_log /dev/null;#access_log /data/logs/fallback_admin_access.log standard;#g' /etc/nginx/conf.d/production.conf

# Create the directory for custom scripts if needed
RUN mkdir -p /docker-entrypoint.d

# Expose the ports (80 for HTTP, 443 for HTTPS, and 9020 for Admin)
EXPOSE 80 443 9020
