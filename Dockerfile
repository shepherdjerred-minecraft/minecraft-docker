FROM openjdk:jdk-slim

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash minecraft
USER minecraft
RUN mkdir /home/minecraft/server
WORKDIR /home/minecraft

ADD download-jar.sh .
ARG MINECRAFT_VERSION=latest
RUN ./download-jar.sh $MINECRAFT_VERSION

WORKDIR /home/minecraft/server
ENTRYPOINT ["java"]
CMD ["-jar", "../minecraft.jar", "nogui"]

VOLUME ["/home/minecraft/server"]
EXPOSE 25565/tcp
EXPOSE 25565/udp
