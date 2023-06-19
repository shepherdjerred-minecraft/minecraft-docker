#!/bin/bash

# https://github.com/Phyremaster/papermc-docker

# Get version information and build download URL and jar name
URL=https://papermc.io/api/v2/projects/paper
if [ "${MC_VERSION}" = latest ]
then
  MC_VERSION=$(wget -qO - $URL | jq -r '.versions[-1]')
fi
URL=${URL}/versions/${MC_VERSION}
if [ "${PAPER_BUILD}" = latest ]
then
  PAPER_BUILD=$(wget -qO - "$URL" | jq '.builds[-1]')
fi
JAR_NAME=paper-${MC_VERSION}-${PAPER_BUILD}.jar
URL=${URL}/builds/${PAPER_BUILD}/downloads/${JAR_NAME}

wget "${URL}" -O "${JAR_NAME}"
