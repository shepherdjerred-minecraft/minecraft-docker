# Spigot Docker
[![CI/CD](https://github.com/shepherdjerred-minecraft/spigot-docker/actions/workflows/docker-publish.yml/badge.svg)
](https://github.com/shepherdjerred-minecraft/spigot-docker/actions/workflows/docker-publish.yml)

A Dockerfile to build both Spigot and Paper

## Features
* Supports the latest versions of Spigot and Paper
* No need to worry about Spigot jarfiles -- just mount a server data directory and go
* Always uses the latest BuildTools.jar
* Checks BitBucket before running build tools.
  * This allows for effective caching. New commits are always picked up, but cached builds are used if no new commits are available.
  * This is an effective strategy for the latest Minecraft version but is less useful if you want to use an older Minecraft version since rebuilds will trigger when unneeded.
* Uses the latest JDK for building and running the Spigot jarfile and the latest stable slim Debian OS image
* GitHub Actions set up to build and deploy changes daily

## Usage

With `docker compose`

```
services:
  minecraft:
    image: ghcr.io/shepherdjerred-minecraft/paper:1.20
    tty: true
    stdin_open: true
    volumes:
      - /path/to/server/files:/home/minecraft/server:z
    ports:
      - 25565:25565/tcp
      - 25565:25565/udp
    command: -Xmx1G -jar "../paper.jar"
    restart: unless-stopped
```

With `docker run`

```
docker run \
  --rm \
  --name %n \
  -p 25565:25565/tcp \
  -p 25565:25565/udp \
  --mount type=bind,source=/server/data,target=/home/minecraft/server \
  -it \
  shepherdjerred/paper:1.20 \
  -Xmx1G \
  -jar "../paper.jar"
```
