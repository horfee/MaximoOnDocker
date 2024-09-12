#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable non root docker users
sudo groupadd docker
sudo usermod -aG docker $USER

# Enable auto start for docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service


# Install portainer
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.1



echo "================================================="
echo "You need now to login against IBM ICR"
echo "You must issue the command "
echo "docker login -u cp -p <entitlement_key> cp.icr.io"
echo "================================================="

echo ""
echo "To run Maximo with oracle, type this "
echo "docker-compose -f docker-compose.ora up"
echo ""
echo "To run Maximo with DB2, type this "
echo "docker-compose -f docker-compose.db2 up"
