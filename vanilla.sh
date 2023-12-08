#!/bin/bash

version="$1"

declare -A versions
versions["1.20.4"]="https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar"

if [ "$version" = "latest" ]
  then
    version="1.20.4"
fi

url="${versions[${version}]}"

wget "$url"
