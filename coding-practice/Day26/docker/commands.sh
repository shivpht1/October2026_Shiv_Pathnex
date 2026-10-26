cat > coding-practice/Day26/docker/commands.sh <<'EOF'
#!/bin/bash

# Display container logs
docker logs pathnex-nginx

# Display detailed container information
docker inspect pathnex-nginx
EOF