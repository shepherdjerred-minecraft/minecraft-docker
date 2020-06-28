FROM openjdk:jdk-slim

RUN useradd -ms /bin/bash minecraft
USER minecraft
RUN mkdir /home/minecraft/server
WORKDIR /home/minecraft

RUN download-jar.sh

WORKDIR /home/minecraft/server
ENTRYPOINT ["java"]
CMD ["-jar", "../minecraft.jar", "nogui"]

VOLUME ["/home/minecraft/server"]
EXPOSE 25565/tcp
EXPOSE 25565/udp
