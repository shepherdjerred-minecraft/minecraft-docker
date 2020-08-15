#!/bin/bash

version="$1"

if [ "$version" = "latest" ]
  then
    version="1.16.1"
fi

if [ "$version" = "1.16.2" ]
  then
    url="https://launcher.mojang.com/v1/objects/c5f6fb23c3876461d46ec380421e42b289789530/server.jar"
elif [ "$version" = "1.16.1" ]
  then
    url="https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar"
elif [ "$version" = "1.15.2" ]
  then
    url="https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
fi

wget "$url"
chown minecraft:minecraft server.jar

