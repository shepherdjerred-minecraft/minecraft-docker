FROM debian:stable AS build

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    default-jdk \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash build_tools
USER build_tools

WORKDIR /home/build_tools
ADD --chown=build_tools:build_tools https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar BuildTools.jar

ARG MINECRAFT_VERSION=latest
RUN java -jar BuildTools.jar --rev $MINECRAFT_VERSION

FROM debian:stable

RUN apt-get update && apt-get install -y \
    default-jdk \
    tmux \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash minecraft
USER minecraft
RUN mkdir /home/minecraft/server
WORKDIR /home/minecraft

COPY --from=build --chown=minecraft:minecraft /home/build_tools/spigot* .
RUN mv spigot* spigot.jar

WORKDIR /home/minecraft/server
ENTRYPOINT ["java"]
CMD ["-Dcom.mojang.eula.agree=true", "-jar", "../spigot.jar"]

VOLUME ["/home/minecraft/server"]
EXPOSE 25565/tcp
EXPOSE 25565/udp
EXPOSE 8123/tcp

