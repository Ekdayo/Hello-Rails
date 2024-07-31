#!/bin/bash
sudo apt-get update -y
sudo apt-get install ca-certificates curl git apt-transport-https software-properties-common -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo curl -L "https://github.com/docker/compose/releases/download/v2.14.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo usermod -aG docker ubuntu

sudo systemctl enable docker

git clone https://github.com/oluwatelid/helloworld.git /home/ubuntu/hello-world-rails-app
cd /home/ubuntu/hello-world-rails-app

git fetch

git pull origin main

docker-compose build --no-cache

docker-compose up -d

docker-compose run web rails db:create db:migrate
