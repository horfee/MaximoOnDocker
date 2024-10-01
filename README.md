
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

## Administrative tasks

To reclaim space from docker, you could run the following scripts

```bash
  docker system prune #delete everything unused ! be careful : if you remove your container, you may loose all images, then rebuilding everything from scratch
```

```bash
  docker builder du #output the total used space for building images
  docker builder prune #remove all used cache
```

To stop a container

```bash
  docker stop <container> #stop the Oracle or DB2 container
```

To start a container

```bash
  docker start <container> #start the Oracle or DB2 container
```

To restart a container

```bash
  docker restart <container> #restart the Oracle or DB2 container
```

Useful docker compose commands 

```bash
  docker compose -f <docker-compose..yml> stop  #stop the full deployment (all containers will be stop but not removed)
  docker compose -f <docker-compose..yml> rm    #remove stopped containers included in the deployment
  docker compose -f <docker-compose..yml> down  #stop and remove containers included in the deployment
  docker compose -f <docker-compose..yml> up    #create and start containers included in the deployment : if you close the terminal, the containers will be stopped
  docker compose -f <docker-compose..yml> up -d #create and start containers included in the deployment in detached mode : if you close the terminal, the containers won't stop
  docker compose -f <docker-compose..yml> up -d --build #create and start containers included in the deployment in detached mode : if you close the terminal, the containers won't stop. The images will be forced to be re created (existing images won't be considered)
```


Maximo initial database installation (maxinst) and update (updatedb) are performed automatically at boot of the maximo container, so you don't need to do it on your own. The problem of updatedb is it requires the application server to not be running ; but if you stop the application server the container will reboot automatically, so it is a dead end... that's why I automate it before the application server starts.

To add additional languages : 
```bash
  docker exec -it maximo /bin/bash -c "cd /opt/IBM/SMP/maximo/tools/maximo && ./TDToolkit.sh -addlang<langcode> -maxmessfix -useexpander"
  docker exec -it maximo /bin/bash -c 'cd /opt/IBM/SMP/maximo/tools/maximo && for pmp in $(find <langcode>/xliff/* -type d -exec basename {} \;); do ./TDToolkit.sh -maxmessfix -useexpander -pmpupdate$pmp; done'

```

or 
```bash
  docker exec -it maximo /bin/bash 
  cd /opt/IBM/SMP/maximo/tools/maximo 
  ./TDToolkit.sh -addlang<langcode> -maxmessfix -useexpander
```

To run a configdb from the command line :
```bash
  docker exec -it maximo /bin/bash -c "cd /opt/IBM/SMP/maximo/tools/maximo && ./configdb.sh"
```

or 
```bash
  docker exec -it maximo /bin/bash 
  cd /opt/IBM/SMP/maximo/tools/maximo 
  ./configdb.sh
```

You can run all legagy commands the same way
Some useful commands can be found here https://bportaluri.com/2012/12/maximo-command-line-reference.html

# Monitoring maxinst progress

During the initial maxinst process, some log files are created in the maximo container.

You can watch the size of these files to have an idea on the datbaase install progress.
2 files are important : Maxinst<timestamp>.log and Updatedb<timestamp>.log

```bash
  docker exec -it maximo /bin/bash -c 'watch "ls -lth /opt/IBM/SMP/maximo/tools/maximo/log/Maxinst*.log /opt/IBM/SMP/maximo/tools/maximo/log/Updatedb*.log"'
```

For maximo data file (see environment variable MAXIMO_DATAFILE in docker compose file) - no demo data:
  - Maxinst<timestamp>.log file is around 85Mo
  - Updatedb<timestamp>.log file
    - Aviation: TBC
    - Health + Strategize: TBC

For maxdemo data file:
  - Maxinst<timestamp>.log file is around 465Mo
  - Updatedb<timestamp>.log file
    - Aviation : 725Mo
    - Health + Strategize : TBC

# Limitations

For now with Aviation, the BDI will bootstrap once the database is healthy, meaning maximo oracle schema is created. It means the BDI will start before the maxinst to be completed ; and of course it will crash and you will have to restart the bdi container once the maxinst is over.
