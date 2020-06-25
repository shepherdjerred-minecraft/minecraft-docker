FROM openjdk:jdk-slim

RUN useradd -ms /bin/bash minecraft
USER minecraft
RUN mkdir /home/minecraft/server
WORKDIR /home/minecraft

ADD --chown=minecraft:minecraft https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar minecraft.jar

WORKDIR /home/minecraft/server
ENTRYPOINT ["java"]
CMD ["-jar", "../minecraft.jar", "nogui"]

VOLUME ["/home/minecraft/server"]
EXPOSE 25565/tcp
EXPOSE 25565/udp
