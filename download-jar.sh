#!/bin/bash

version="$1"

declare -A versions
versions["1.15.2"]="https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
versions["1.16.1"]="https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar"
versions["1.16.2"]="https://launcher.mojang.com/v1/objects/c5f6fb23c3876461d46ec380421e42b289789530/server.jar"
versions["1.16.3"]="https://launcher.mojang.com/v1/objects/f02f4473dbf152c23d7d484952121db0b36698cb/server.jar"
versions["1.16.4"]="https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar"
versions["1.16.5"]="https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar"

if [ "$version" = "latest" ]
  then
    version="1.16.4"
fi

url="${versions[${version}]}"

wget "$url"
chown minecraft:minecraft server.jar

