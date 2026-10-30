cat > coding-practice/Day30/docker/Dockerfile <<'EOF'
FROM nginxinc/nginx-unprivileged:stable

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -fsS http://localhost:8080/ || exit 1
EOF