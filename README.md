# spigot-docker
[![CI/CD](https://github.com/shepherdjerred-minecraft/spigot-docker/actions/workflows/docker-publish.yml/badge.svg)
](https://github.com/shepherdjerred-minecraft/spigot-docker/actions/workflows/docker-publish.yml)

## Features
* No need to worry about spigot jarfiles -- just mount a server data directory and go
* Always uses the latest BuildTools.jar
* Checks BitBucket before running build tools.
  * This allow for effective caching. New commits are always picked up, but cached builds are used if no new commits are available.
  * This is an effective strategy for the latest Minecraft version, but is less useful if you want to use an older Minecraft version since rebuilds will trigger when unneeded.
* Uses the latest JDK for building and running the spigot jarfile and the latest stable slim debian OS image
* Travis CI setup to build and deploy changes daily
