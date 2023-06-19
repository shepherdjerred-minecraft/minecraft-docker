# Minecraft Docker Images

[![CI/CD](https://github.com/shepherdjerred-minecraft/spigot-docker/actions/workflows/earthly.yml/badge.svg)
](https://github.com/shepherdjerred-minecraft/spigot-docker/actions/workflows/earthly.yml)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/shepherdjerred-minecraft/minecraft-docker?quickstart=1)

A Dockerfile to build and run both Spigot, Paper and Vanilla Minecraft.

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

Install [Earthly](https://earthly.dev/get-earthly) and then run `earthly +images` in this directory.

### Adding a New Minecraft Version

New versions are easy.

1. Add the version to the [Earthfile](https://github.com/shepherdjerred-minecraft/minecraft-docker/blob/5d761d32cc3b333db4a1f4b2be07d1fd48d29341/Earthfile#L78)
2. Add the URL to the vanilla .jar in [`vanilla.sh`](https://github.com/shepherdjerred-minecraft/minecraft-docker/blob/5d761d32cc3b333db4a1f4b2be07d1fd48d29341/vanilla.sh#L6)

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
