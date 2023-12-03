#!/bin/bash

echo 'Coded by Tim Samanchi Dec 2023!' > /tmp/README.txt


sudo apt-get update
sudo apt-get -y upgrade

# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get -y install \
                curl \
                ca-certificates \
                apt-transport-https \
                gnupg \
                gnupg-agent \
                install software-properties-common \
                lsb-release
lsb_release -a >> /tmp/README.txt                

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index again and install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# Add your user to the docker group to run Docker commands without sudo (optional)
sudo usermod -aG docker $USER

# Print a message indicating the installation is complete
echo "Docker has been successfully installed. You may need to log out and log back in for the changes to take effect." >> /tmp/README.txt

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get -y install \ 
                fontconfig openjdk-17-jre \
                jenkins \
                gnome-terminal

# Download kubectl binary
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
source ~/.bashrc

sudo apt-get update
sudo apt-get -y install \
                build-essential \
                python3 \
                python3-pip \
                ngnix \
                git \
                unzip
sudo pip3 install awsebcli

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get -y install terraform

sudo fallocate -l 1G /var/swapfile
sudo chmod 600 /var/swapfile
sudo mkswap /var/swapfile
sudo swapon /var/swapfile
echo '/var/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl -p

sudo systemctl start jenkins
sudo systemctl enable jenkins  
sudo systemctl restart nginx
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo cat /var/lib/jenkins/secrets/initialAdminPassword