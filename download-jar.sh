#!/bin/bash

if [ "$MINECRAFT_VERSION" = "latest" ]
  then
    MINECRAFT_VERSION = "1.16.1"
fi

if [ "$MINECRAFT_VERSION" = "1.16.1" ]
  then
    DOWNLOAD_URL = "https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar"
fi

wget $DOWNLOAD_URL
chown minecraft:minecraft server.jar
