#!/bin/bash

POSITIONAL_ARGS=()

entitlementkey=
type=
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "Usage is $0 [-e|--entitlementkey <entitlement_key> -t|--type oracle/db2]"
      exit 0
      ;;
    -t|--type)
      type=$(echo -n $2 | awk '{print tolower($0)}')
      shift # past argument
      shift # past value
      ;;
    -e|--entitlementkey)
      entitlementkey="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

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
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.1



if [[ -z "${entitlementkey}" ]]; then
  echo "================================================="
  echo "You need now to login against IBM ICR"
  echo "================================================="

  echo -n "Enter ibm entitlement key : "
  read entitlementkey
  echo $entitlementkey
fi

echo "Trying to login against IBM ICR"
sudo docker login -u cp -p $entitlementkey cp.icr.io

if [[ $? != 0 ]]; then
  echo "Credentials seems to be wrong. please verify"
  exit 1
fi

while [[ -z "${type}" ]]; 
do
  echo "What kind of deployment do you want to use ?"
  echo "1) Oracle"
  echo "2) DB2"
  echo -n "Your choice : "
  read type
  if [[ "${type}" != "1" && "${type}" != "2" ]]; then
    type=
  fi
done

if [[ "${type}" == "1" ]] || [[ "${type}" == "oracle" ]]; then
  echo "You choose oracle as deployment"
  sudo chown 54321:${USER} oracle-db/data
  sudo docker compose -f docker-compose.ora up -d
elif [[ "${type}" == "2" ]] || [[ "${type}" == "db2" ]]; then
  echo "You choose DB2 as deployment"
  sudo docker compose -f docker-compose.db2 up -d
fi
