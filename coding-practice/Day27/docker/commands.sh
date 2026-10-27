cat > coding-practice/Day27/docker/commands.sh <<'EOF'
#!/bin/bash

# Open a shell inside the running Nginx container
docker exec -it pathnex-nginx bash

# Display live container resource usage
docker stats

# Run Nginx with memory and CPU limits
docker run -d --name pathnex-limited-nginx \
  --memory="512m" \
  --cpus="1.0" \
  nginx
EOF