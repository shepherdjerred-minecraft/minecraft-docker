# Spigot Docker

[![CI/CD](https://github.com/shepherdjerred-minecraft/spigot-docker/actions/workflows/earthly.yml/badge.svg)
](https://github.com/shepherdjerred-minecraft/spigot-docker/actions/workflows/earthly.yml)

A Dockerfile to build and run both Spigot and Paper.

## Features

* Uses the latest Amazon Coretto for the current Java LTS (currently Java 17)
* Supports the latest versions of Spigot, Paper, and Vanilla Minecraft
* No need to worry about server jarfiles -- just mount a server data directory and go
* Always uses the latest build tools for Spigot and Paper
* Automatically builds every day

## Images

Pre-built images are located here:

* [Vanilla](https://github.com/shepherdjerred-minecraft/spigot-docker/pkgs/container/vanilla)
* [Spigot](https://github.com/shepherdjerred-minecraft/spigot-docker/pkgs/container/spigot)
* [Paper](https://github.com/shepherdjerred-minecraft/spigot-docker/pkgs/container/paper)

## Building

Install [Earthly](https://earthly.dev/get-earthly) and then run `earthly +build` in this directory.

## Usage

The Docker image has a filesystem as follows:

```text
/home/minecraft/
├── server.jar
└── server/
    └── plugins/
```

The working directory of the image is at `/home/minecraft/server`. Your server files should be mounted at `/home/minecraft/server`. To use the `.jar` provided by the image, you'll have to pass the argument `-jar ../server.jar` to Docker so that Java is invoked correctly. This is a bit confusing, but it allows end-users to easily bind-mount their server files.

Note that the server directory _does not_ have a server jarfile.

## Docker Compose

```yml
services:
  minecraft:
    # Swap paper for `spigot` or `minecraft`
    # Swap `1.20` with `latest` or another version of Minecraft
    image: ghcr.io/shepherdjerred-minecraft/paper:1.20
    tty: true
    stdin_open: true
    volumes:
      # Change `/path/to/server/files` to the absolute path that your sever fiels are located at
      # Do NOT change `/home/minecraft/server`
      - /path/to/server/files:/home/minecraft/server:z
    ports:
      # Change the first 25565 to another port if needed
      - 25565:25565/tcp
      - 25565:25565/udp
    # Change how much memory you're giving Java if needed
    # Do NOT change `../server.jar`
    command: -Xmx1G -jar "../server.jar"
    restart: unless-stopped
```

## `docker run`

```bash
docker run \
  --rm \
  --name %n \
  # Change the first 25565 to another port if needed
  -p 25565:25565/tcp \
  -p 25565:25565/udp \
  # Change `/path/to/server/files` to the absolute path that your sever fiels are located at
  # Do NOT change `/home/minecraft/server`
  --mount type=bind,source=/path/to/server/files,target=/home/minecraft/server \
  -it \
  # Swap paper for `spigot` or `minecraft`
  # Swap `1.20` with `latest` or another version of Minecraft
  ghcr.io/shepherdjerred-minecraft/paper:1.20 \
  # Change how much memory you're giving Java if needed
  -Xmx1G \
  # Do NOT change `../server.jar`
  -jar "../server.jar"
```
