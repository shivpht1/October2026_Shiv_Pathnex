cat > coding-practice/Day29/docker/Dockerfile <<'EOF'
FROM nginx:stable

# Create an unprivileged application user
RUN useradd --system --no-create-home --shell /usr/sbin/nologin pathnexuser

# Use a non-root user
USER pathnexuser
EOF