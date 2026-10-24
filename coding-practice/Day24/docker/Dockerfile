cat > coding-practice/Day24/docker/Dockerfile <<'EOF'
FROM nginx:stable

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost/ || exit 1

EXPOSE 80
EOF