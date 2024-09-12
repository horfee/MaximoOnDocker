#!/bin/bash

sed -i -e "s/\(mxe.db.schemaowner\)=\(.*\)/\1=$MXE_DB_SCHEMAOWNER/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
sed -i -e "s/\(mxe.db.url\)=\(.*\)/\1=${MXE_DB_URL//\//\\/}/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
sed -i -e "s/\(mxe.db.driver\)=\(.*\)/\1=$MXE_DB_DRIVER/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
sed -i -e "s/\(mxe.db.user\)=\(.*\)/\1=$MXE_DB_USER/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
sed -i -e "s/\(mxe.db.password\)=\(.*\)/\1=$MXE_DB_PASSWORD/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties