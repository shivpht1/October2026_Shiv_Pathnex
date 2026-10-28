cat > coding-practice/Day28/docker/commands.sh <<'EOF'
#!/bin/bash

# Save a Docker image to a tar archive
docker save -o pathnex-nginx.tar pathnex-nginx

# Load a Docker image from a tar archive
docker load -i pathnex-nginx.tar

# Back up a Docker named volume
docker run --rm \
  -v pathnex-volume:/data \
  -v "$(pwd):/backup" \
  ubuntu \
  tar czf /backup/pathnex-backup.tar.gz -C /data .
EOF