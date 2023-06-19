FROM ubuntu:jammy AS download
WORKDIR /workspace

RUN apt update -y && apt install -y wget jq
COPY --chmod=0755 paper.sh .

ENV MC_VERSION="latest"
ENV PAPER_BUILD="latest"

RUN ./paper.sh

# Container for running Paper
FROM openjdk:17-jdk-slim

RUN apt-get update && apt-get install -y \
  webp
  && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash minecraft
USER minecraft
RUN mkdir /home/minecraft/server
WORKDIR /home/minecraft

COPY --from=download --chown=minecraft:minecraft /workspace/paper*.jar .
RUN mv paper* paper.jar

WORKDIR /home/minecraft/server
ENTRYPOINT ["java"]
CMD ["-Dcom.mojang.eula.agree=true", "-jar", "../paper.jar"]

VOLUME ["/home/minecraft/server"]
EXPOSE 25565/tcp
EXPOSE 25565/udp
