#!/bin/bash

POSITIONAL_ARGS=()

entitlementkey=
type=
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "Usage is $0 [-e|--entitlementkey <entitlement_key>]"
      exit 0
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



dockerexists=$(docker -v)
dockerexists=$?

if [[ "${dockerexists}" != "0" ]]; then
  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get -f install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install -f docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  
  # Enable non root docker users
  sudo groupadd docker
  sudo usermod -aG docker $USER

  # Enable auto start for docker
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service


  # Install portainer
  sudo docker volume create portainer_data
  sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.1
fi

skopeoexists=$(skopeo -v)
skopeoexists=$?

if [[ "${skopeoexists}" != "0" ]]; then
  sudo apt-get install -f skopeo
fi

  
if [[ -z "${entitlementkey}" ]]; then   # entitlement key not provided : we must test if already provided ; if not, need to request it from stdin

  needsentitlementkey=$(sudo skopeo list-tags docker://cp.icr.io/cp/manage/manageadmin)
  needsentitlementkey=$?

  if [[ "${needsentitlementkey}" == "0" ]]; then
    echo "Existing credentials seems correct."
    echo "No need to provide them again."
    echo ""
  else
    echo "================================================="
    echo "You need now to login against IBM ICR"
    echo "================================================="

    echo -n "Enter ibm entitlement key : "
    read entitlementkey
    echo $entitlementkey

    echo "Trying to login against IBM ICR"
    sudo docker login -u cp -p $entitlementkey cp.icr.io

    if [[ $? != 0 ]]; then
      echo "Credentials seems to be wrong. please verify"
      exit 1
    fi

    #everything is fine, but as we are running docker login with sudo, the credentials are stored in the root home directory
    #we need to copy it locally if we want run later docker commands without sudo
    if [ ! -d "$HOME/.docker/" ]; then
      mkdir $HOME/.docker
    fi
    
    sudo cp /root/.docker/config.json $HOME/.docker/
    sudo chown $USER:$USER /$HOME/.docker/config.json

  fi

  
else    # entitlement key provided : we need to override if one already exists
  echo "Trying to login against IBM ICR"
  sudo docker login -u cp -p $entitlementkey cp.icr.io

  if [[ $? != 0 ]]; then
    echo "Credentials seems to be wrong. please verify"
    exit 1
  fi

fi


user_choice=
deployments=($(ls -1 *.desc))
nbdeployments=${#deployments[@]}

while [[ -z "${user_choice}" ]];
do

  echo "What kind of deployment do you want to use ?"
  i=0
  for deployf in ${deployments[@]}
  do
    echo "$((i+1))> $(cat $deployf)"
    ((i++))
  done

  echo -n "Your choice (Control+C to quit): "
  read user_choice
  if [[ "${user_choice}" -lt "0" ]] || [[ "${user_choice}" -gt "${nbdeployments}" ]] || [[ $((user_choice)) != $user_choice ]]; then
    user_choice=
    echo "Invalid choice"
  fi
done

echo "Restoring Oracle DB prereqs ownership for data folder"
sudo mkdir -p oracle-db/data
sudo chown 54321:$USER oracle-db/data

deployment=${deployments[$((user_choice-1))]:0:-5}
echo "Deployment selected : $deployment"
sudo docker compose -f $deployment up -d
