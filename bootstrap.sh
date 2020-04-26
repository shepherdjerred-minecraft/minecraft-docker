1. Install Docker
2. Create folder for Docker images on root partition
3. Pull Dockerfile from GitHub
4. Build Docker image
5. Mount EBS volume onto /server
6. Start Docker image exposing ports and binding to EBS volume

#!/bin/bash
sudo yum update -y
sudo yum install -y docker git tmux

sudo groupadd docker
sudo gpasswd -a ec2-user docker
sudo systemctl enable docker
sudo systemctl restart docker

git clone https://github.com/ShepherdJerred-minecraft/spigot-docker
cd spigot-docker

docker build -t shepherdjerred/spigot:latest .

sudo mkdir /server
sudo mkdir /server/data
sudo chown ec2-user:ec2-user /server/data
# ONLY IF NEW EBS VOLUME
# sudo mkfs -t ext4 /dev/xvdf

sudo mount /dev/xvdf /server
echo "/dev/xvdf /server ext4 defaults 0 0" | sudo tee -a /etc/fstab

# Copy file to force jar update
id=$(docker create shepherdjerred/spigot:latest)
docker cp $id:/home/minecraft/server/spigot.jar /server/data
docker rm -v $id

tmux new -s -d minecraft
tmux send-keys "sudo docker run -p 25565:25565/tcp -p 25565:25565/udp --mount type=/server/data,source=minecraft,target=/home/minecraft/server shepherdjerred/spigot:latest"
tmux send-keys Enter
tmux attach minecraft
