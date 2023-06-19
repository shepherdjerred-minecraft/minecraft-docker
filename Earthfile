VERSION 0.7
FROM amazoncorretto:17
WORKDIR /workspace

build.base:
  RUN yum update -y && yum install -y wget jq git

build.paper:
  ARG --required version
  FROM +build.base
  COPY paper.sh .
  RUN PAPER_BUILD="latest" MC_VERSION=$version ./paper.sh
  RUN mv paper*.jar server.jar
  SAVE ARTIFACT server.jar

build.spigot.repos:
  FROM +build.base
  RUN git clone https://hub.spigotmc.org/stash/scm/spigot/spigot.git Spigot
  RUN git clone https://hub.spigotmc.org/stash/scm/spigot/craftbukkit.git CraftBukkit
  RUN git clone https://hub.spigotmc.org/stash/scm/spigot/bukkit.git Bukkit
  RUN git clone https://hub.spigotmc.org/stash/scm/spigot/builddata.git BuildData
  SAVE ARTIFACT *

build.spigot:
  ARG --required version
  FROM +build.base
  COPY +build.spigot.repos/ .
  RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar
  RUN java -jar BuildTools.jar --rev $version
  RUN mv spigot*.jar server.jar
  SAVE ARTIFACT server.jar

build.vanilla:
  ARG --required version
  FROM +build.base
  COPY vanilla.sh .
  RUN ./vanilla.sh $version
  SAVE ARTIFACT server.jar

image.base:
  ARG --required version
  RUN yum update -y && yum install -y libwebp /usr/sbin/adduser
  RUN adduser -ms /bin/bash minecraft
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
  SAVE IMAGE shepherdjerred-minecraft/spigot:$version
  SAVE IMAGE --push ghcr.io/shepherdjerred-minecraft/spigot:$version

image.paper:
  ARG --required version
  FROM +image.base
  COPY --chown=minecraft:minecraft +build.paper/server.jar .
  WORKDIR /home/minecraft/server
  SAVE IMAGE shepherdjerred-minecraft/paper:$version
  SAVE IMAGE --push ghcr.io/shepherdjerred-minecraft/paper:$version

image.vanilla:
  ARG --required version
  FROM +image.base
  COPY --chown=minecraft:minecraft +build.vanilla/server.jar .
  WORKDIR /home/minecraft/server
  SAVE IMAGE shepherdjerred-minecraft/vanilla:$version
  SAVE IMAGE --push ghcr.io/shepherdjerred-minecraft/vanilla:$version

images:
  ARG versions=latest 1.20.1
  FOR version IN $versions
    BUILD +image.paper --version=$version
    BUILD +image.spigot --version=$version
    BUILD +image.vanilla --version=$version
  END
