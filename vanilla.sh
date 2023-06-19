#!/bin/bash

version="$1"

declare -A versions
versions["1.20.1"]="https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar"

if [ "$version" = "latest" ]
  then
    version="1.20.1"
fi

url="${versions[${version}]}"

wget "$url"
