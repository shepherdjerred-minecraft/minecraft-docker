FROM openjdk:17-jdk-slim AS build

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Run Spigot Build Tools
RUN useradd -ms /bin/bash build_tools
USER build_tools

WORKDIR /home/build_tools
ADD --chown=build_tools:build_tools https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar BuildTools.jar

# Query bitbucket for latest commits -- allows us to only build when there is a change
ADD https://hub.spigotmc.org/stash/rest/api/latest/projects/SPIGOT/repos/spigot/commits?until=master&limit=0&start=0 spigot.json
ADD https://hub.spigotmc.org/stash/rest/api/latest/projects/SPIGOT/repos/bukkit/commits?until=master&limit=0&start=0 bukkit.json
ADD https://hub.spigotmc.org/stash/rest/api/latest/projects/SPIGOT/repos/craftbukkit/commits?until=master&limit=0&start=0 craftbukkit.json
ADD https://hub.spigotmc.org/stash/rest/api/latest/projects/SPIGOT/repos/builddata/commits?until=master&limit=0&start=0 builddata.json
ARG MINECRAFT_VERSION=latest
RUN java -jar BuildTools.jar --rev $MINECRAFT_VERSION

# Container for running Spigot
FROM openjdk:17-jdk-slim

RUN useradd -ms /bin/bash minecraft
USER minecraft
RUN mkdir /home/minecraft/server
WORKDIR /home/minecraft

COPY --from=build --chown=minecraft:minecraft /home/build_tools/spigot*.jar .
RUN mv spigot* spigot.jar

WORKDIR /home/minecraft/server
ENTRYPOINT ["java"]
CMD ["-Dcom.mojang.eula.agree=true", "-jar", "../spigot.jar"]

VOLUME ["/home/minecraft/server"]
EXPOSE 25565/tcp
EXPOSE 25565/udp

