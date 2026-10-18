
cat > coding-practice/Day18/docker/redis-commands.md <<'EOF'
# Day 18 — Docker Redis Container

## 1. Pull the Redis Image

```bash
docker pull redis:7
```

## 2. Run Redis with Persistent Storage

```bash
docker volume create pathnex-redis-data

docker run -d \
  --name pathnex-redis \
  -p 6379:6379 \
  -v pathnex-redis-data:/data \
  redis:7 \
  redis-server --appendonly yes
```

## 3. Check the Running Container

```bash
docker ps
docker logs pathnex-redis
docker inspect pathnex-redis
```

## 4. Connect to Redis CLI

```bash
docker exec -it pathnex-redis redis-cli
```

## 5. Test Redis Commands

Run these commands inside the Redis CLI:

```text
PING
SET app_name PathNex
GET app_name
SET environment dev
GET environment
KEYS *
```

Expected response for PING:

```text
PONG
```

Exit the Redis CLI:

```text
EXIT
```

## 6. Verify Persistent Data

```bash
docker exec -it pathnex-redis redis-cli SET username Shiv
docker restart pathnex-redis
docker exec -it pathnex-redis redis-cli GET username
```

The value should remain available because Redis uses a named volume and AOF persistence.

## 7. Stop and Remove the Container

```bash
docker stop pathnex-redis
docker rm pathnex-redis
```

The named volume remains after container removal.

To remove the volume too, after confirming you no longer need its data:

```bash
docker volume rm pathnex-redis-data
```

## Key Concepts

- Image: Redis 7
- Container: pathnex-redis
- Port mapping: host port 6379 to container port 6379
- Data directory: /data
- Named volume: pathnex-redis-data
- Persistence: Redis AOF enabled
EOF
