#!/bin/bash
# Install some dependencies
sudo yum update -y
sudo yum install -y docker git tmux

# Add docker group
sudo groupadd docker
sudo gpasswd -a ec2-user docker
sudo systemctl enable docker
sudo systemctl restart docker

# Clone this repository
git clone https://github.com/ShepherdJerred-minecraft/spigot-docker
cd spigot-docker

# Make server mount point
sudo mkdir -b /server/data
sudo chown ec2-user:ec2-user /server/data

# Format EBS volume if it isn't already ext4
blkid --match-token TYPE=ext4 /dev/xvdf || sudo mkfs -t ext4 /dev/xvdf

# Mount EBS volume, add to fstab
sudo mount /dev/xvdf /server
echo "/dev/xvdf /server ext4 defaults 0 0" | sudo tee -a /etc/fstab

# TODO register docker service
