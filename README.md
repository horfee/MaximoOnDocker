
# Maximo On Docker

This project is aimed to help you deploy automatically Maximo Manage 8 and above on your local ubuntu VM, with few clicks.


## Pre-reqs

You need to have Ubuntu installed up and running, with sudoer role (by default) and git.
To install git :
```bash
  sudo apt update
  sudo apt install git
```

## Deployment

Open a terminal, and type this:

```bash
  git clone https://github.com/horfee/MaximoOnDocker
  cd MaximoOnDocker
  ./initialize.sh [-e entitlement_key]
```
The parameters are optional and will be asked during initialization if not provided as arguments.

The  prompt will update the apt-get registry, add Docker official repo and install docker engine.

See https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Then it will also deploy portainer in order to manage with a dashboard all you docker containers.

_For now, I had issue with portainer connecting to IBM ICR Repository, so we will create and deploy the stack through docker compose command, not through the portainer UI._

This deployment offers you two ways :
- with Oracle Free DB : https://container-registry.oracle.com/ords/f?p=113:4:113972032376196:::4:P4_REPOSITORY,AI_REPOSITORY,AI_REPOSITORY_NAME,P4_REPOSITORY_NAME,P4_EULA_ID,P4_BUSINESS_AREA_ID:1863,1863,Oracle%20Database%20Free,Oracle%20Database%20Free,1,0&cs=37qDiIwGnCrtY9MldXpID3I0Ti0mv8QqOlFwtRVHg4mcGJfVSnuddp5WDvM6dCLEfVCfuDfILMTU55H249FK9ow
- with IBM DB2 : https://www.ibm.com/docs/en/db2/11.5?topic=system-linux

For both, we are using liberty profile deployment as it is the standard deployment for Maximo Manage.

The script wil ask you which dpeloyment you want to start, based on <deployment.ora.desc> files

Additionally, if needed you can modify the images used to fetch databases and application server.

For Oracle DB :
```bash
  cd MaximoOnDocker
  sudo chown 54321:${USER} oracle-db/data 
  docker compose -f docker-compose.ora -d up
```

For IBM DB2 :
```bash
  cd MaximoOnDocker
  docker compose -f docker-compose.db2 -d up
```

__The flag -d is meant to run detached, meaning you could close the terminal and not stop the deployment.__

Your docker compose will boot up, creating database instances ready to be used by Maximo. The application server will first check if maxinst or updatedb is required before starting. if so, the process will be triggered automatically, and once the process ends successfully, the app server will start, otherwise the system will restart the maximo container after 2minutes.


Your maximo instance will be available by default at http://localhost:9080/maximo

## Next steps

Don't forget to configure doclinks : a volume is already bound with path /opt/IBM/doclinks

You can also run updatedb.sh command if you need to upgrade the version, tdtoolkit to add languages, etc.

The script check-images-updates.sh lets you know if your dockerfile could be updated or not, and apply the modifications if you choose so.

```bash
  cd MaximoOnDocker
  ./check-images-updates.sh maximo/Dockerfile
```
