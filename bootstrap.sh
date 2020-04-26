#!/bin/bash
sudo yum update -y
sudo yum install -y docker git

mkdir ~/docker
cd ~/docker

git clone https://github.com/ShepherdJerred-minecraft/spigot-docker
cd spigot-docker

sudo systemctl start docker
sudo docker build -t shepherdjerred/spigot:latest .

sudo mkdir /server
# ONLY IF NEW
sudo mkfs -t ext4 /dev/xvdf

sudo mount /dev/xvdf /server
echo "/dev/xvdf /server ext4 defaults 0 0" | sudo tee -a /etc/fstab

# Copy file to force jar update
# sudo docker cp shepherdjerred/spigot:latest:/home/minecraft/server/spigot.jar /server/

sudo docker run -p 25565:25565/tcp -p 25565:25565/udp --mount type=bind,source=/server,target=/home/minecraft/server shepherdjerred/spigot:latest
