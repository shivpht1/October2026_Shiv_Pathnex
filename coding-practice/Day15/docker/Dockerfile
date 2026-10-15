
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD ["echo", "Hello Pathnex - Day15 Docker Practice"]
