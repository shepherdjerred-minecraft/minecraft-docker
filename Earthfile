VERSION 0.7
FROM amazoncorretto:17
WORKDIR /workspace

build.base:
  RUN yum update -y && yum install -y wget jq git

build.paper:
  ARG --required version
  FROM +build.base
  COPY --chmod=0755 paper.sh .
  RUN PAPER_BUILD="latest" MC_VERSION=$version ./paper.sh
  RUN mv paper* server.jar
  SAVE ARTIFACT server.jar

build.spigot:
  ARG --required version
  FROM +build.base
  RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
  RUN java -jar BuildTools.jar --rev $version
  RUN mv spigot* server.jar
  SAVE ARTIFACT server.jar

build.vanilla:
  ARG --required version
  FROM +build.base
  COPY download-jar.sh .
  ARG MINECRAFT_VERSION=latest
  RUN ./download-jar.sh $MINECRAFT_VERSION
  SAVE ARTIFACT server.jar

image.base:
  ARG --required version

  # for dynmap
  RUN yum update -y && yum install -y webp

  RUN useradd -ms /bin/bash minecraft
  USER minecraft
  RUN mkdir /home/minecraft/server
  WORKDIR /home/minecraft
  ENTRYPOINT ["java"]
  VOLUME ["/home/minecraft/server"]
  EXPOSE 25565/tcp
  EXPOSE 25565/udp
  CMD ["-Dcom.mojang.eula.agree=true", "-jar", "../server.jar"]

image.spigot:
  ARG --required version
  FROM +image.base
  COPY --chown=minecraft:minecraft +build.spigot/server.jar .
  WORKDIR /home/minecraft/server
  SAVE IMAGE --push ghcr.io/shepherdjerred-minecraft/spigot:$version

image.paper:
  ARG --required version
  FROM +image.base
  COPY --chown=minecraft:minecraft +build.paper/server.jar .
  WORKDIR /home/minecraft/server
  SAVE IMAGE --push ghcr.io/shepherdjerred-minecraft/paper:$version

image.vanilla:
  ARG --required version
  FROM +image.base
  COPY --chown=minecraft:minecraft +build.vanilla/server.jar .
  WORKDIR /home/minecraft/server
  SAVE IMAGE --push ghcr.io/shepherdjerred-minecraft/vanilla:$version

images:
  ARG versions=latest 1.20.1
  FOR version IN $versions
    BUILD +image.paper --version=$version
    BUILD +image.spigot --version=$version
    BUILD +image.vanilla --version=$version
  END
