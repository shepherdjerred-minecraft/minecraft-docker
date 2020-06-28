#!/bin/bash

version="$1"

if [ "$version" = "latest" ]
  then
    version="1.16.1"
fi

if [ "$version" = "1.16.1" ]
  then
    url="https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar"
fi

wget "$url"
chown minecraft:minecraft server.jar

