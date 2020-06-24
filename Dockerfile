FROM openjdk:jdk-slim

RUN useradd -ms /bin/bash minecraft
USER minecraft
RUN mkdir /home/minecraft/server
WORKDIR /home/minecraft

# 1.16
ADD https://launcher.mojang.com/v1/objects/a0d03225615ba897619220e256a266cb33a44b6b/server.jar minecraft.jar

WORKDIR /home/minecraft/server
ENTRYPOINT ["java"]
CMD ["-Dcom.mojang.eula.agree=true", "-jar", "../minecraft.jar", "nogui"]

VOLUME ["/home/minecraft/server"]
EXPOSE 25565/tcp
EXPOSE 25565/udp
