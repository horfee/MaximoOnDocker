FROM cp.icr.io/cp/manage/extension-health:9.1.2 AS HEALTH
# FROM cp.icr.io/cp/manage/extension-aviation:8.1.12 AS AVIATION
# FROM cp.icr.io/cp/manage/bdi:8.3.2 AS BDI
# FROM cp.icr.io/cp/manage/extension-civil:8.6.2 AS CIVIL
# FROM cp.icr.io/cp/manage/extension-nuclear:9.0.5 AS NUCLEAR
# FROM cp.icr.io/cp/manage/extension-oilandgas:8.1.8 AS OILANDGAS
# FROM cp.icr.io/cp/manage/extension-transportation:9.0.2 AS TRANSPORTATION
# FROM cp.icr.io/cp/manage/extension-utilities:8.1.6 AS UTILITIES
# FROM cp.icr.io/cp/manage/extension-serviceprovider:9.0.4 AS SERVICEPROVIDER
# FROM cp.icr.io/cp/manage/extension-acm:8.1.11 AS ACM
# FROM cp.icr.io/cp/manage/extension-hse:9.0.9 AS HSE
# FROM cp.icr.io/cp/manage/extension-spatial:8.7.1 AS SPATIAL
FROM cp.icr.io/cp/manage/extension-strategize:9.1.1 AS STRATEGIZE
# FROM cp.icr.io/cp/manage/extension-icd:9.0.6 AS ICD

FROM cp.icr.io/cp/manage/manageadmin:9.1.65 AS BASE

WORKDIR /opt/IBM/SMP/maximo


######## HEALTH ########
COPY --chown=1000:0 --from=HEALTH /extension.zip /opt/IBM/SMP/maximo/
RUN \
  unzip -o ./extension.zip && rm ./extension.zip &&\
  unzip -o tools/maximo/en/assethealth/package.zip -d tools/maximo
######## END OF HEALTH ########

######## HSE ########
#COPY --chown=1000:0 --from=HSE /extension.zip /opt/IBM/SMP/maximo/
#RUN \
#  unzip -o ./extension.zip && rm ./extension.zip &&\
#  unzip -o tools/maximo/en/hse/package.zip -d tools/maximo
######## END OF HEALTH ########

######## ICD ########
#COPY --chown=1000:0 --from=ICD /extension.zip /opt/IBM/SMP/maximo/
#RUN \
#  unzip -o ./extension.zip && rm ./extension.zip &&\
#  unzip -o tools/maximo/en/icd/package.zip -d tools/maximo
######## END OF ICD ########

######## SERVICEPROVIDER ########
#COPY --chown=1000:0 --from=SERVICEPROVIDER /extension.zip /opt/IBM/SMP/maximo/
#RUN \
#  unzip -o ./extension.zip && rm ./extension.zip &&\
#  unzip -o tools/maximo/en/serviceprovider/package.zip -d tools/maximo
######## END OF SERVICEPROVIDER ########

######## STRATEGIZE ########
COPY --chown=1000:0 --from=STRATEGIZE /extension.zip /opt/IBM/SMP/maximo/
RUN \
  unzip -o ./extension.zip && rm ./extension.zip &&\ 
  unzip -o tools/maximo/en/strategize/package.zip -d tools/maximo
######## END OF STRATEGIZE ########

######## NUCLEAR ########
#COPY --chown=1000:0 --from=NUCLEAR /extension.zip /opt/IBM/SMP/maximo/
#RUN \
#  unzip -o ./extension.zip && rm ./extension.zip &&\ 
#  unzip -o tools/maximo/en/nuclear/package.zip -d tools/maximo
######## END OF NUCLEAR ########

######## TRANSPORTATION ########
#COPY --chown=1000:0 --from=TRANSPORTATION /extension.zip /opt/IBM/SMP/maximo/
#RUN \
#  unzip -o ./extension.zip && rm ./extension.zip &&\ 
#  unzip -o tools/maximo/en/transportation/package.zip -d tools/maximo
######## END OF TRANSPORTATION ########

WORKDIR /opt/IBM/SMP/maximo
RUN for i in $(ls -1 lang/*.zip); do unzip $i;done

WORKDIR /opt/IBM/SMP/maximo/tools/maximo

RUN \
  mkdir -p /opt/IBM/SMP/maximo/applications/maximo/businessobjects/classes/psdi/app/signature/apps &&\
  mkdir -p /opt/IBM/SMP/maximo/tools/maximo/log &&\
  ./pkginstall.sh && ./updatedblitepreprocessor.sh -disconnected &&\
  find /opt/IBM/SMP/maximo/applications -type d -exec chmod 777 {} + &&\
  chmod ugo+rw -R /opt/IBM/SMP/maximo/applications &&\
  find /opt/IBM/SMP/maximo/tools/maximo -type d -exec chmod 777 {} + &&\
  chmod ugo+rw -R /opt/IBM/SMP/maximo/tools/maximo &&\
  chmod 777 /opt/IBM/SMP/maximo/tools/maximo/log &&\
  find /opt/IBM/SMP/maximo/tools/maximo/en -type f -name postupdatedb.sh -exec chmod -v 777 {} + &&\
  find /opt/IBM/SMP/maximo/tools/maximo/en -type f -name postpreprocessor.sh -exec chmod -v 777 {} +

# RUN find /opt/IBM/SMP/maximo/tools/maximo/en -type f -name postpreprocessor.sh -exec {} \;

WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-servers/maximo-all/maximo-all-server
RUN mv server.xml server-oidc.xml
RUN mv server-dev.xml server.xml

## Replace web.xml for maximo-all maximo-x
#WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maximo-x/webmodule/WEB-INF/
#RUN mv web.xml web-oidc.xml
#RUN mv web-guest.xml  web-guest-oidc.xml
#RUN mv web-dev.xml  web.xml
#RUN mv web-guest-dev.xml  web-guest.xml

## Replace web.xml for maximo-all maximouiweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maximouiweb/webmodule/WEB-INF/
RUN mv /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maximouiweb/webmodule/WEB-INF/web.xml /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maximouiweb/webmodule/WEB-INF/web-oidc.xml
RUN mv /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maximouiweb/webmodule/WEB-INF/web-dev.xml /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maximouiweb/webmodule/WEB-INF/web.xml


## Replace web.xml for maximo-all maxrestweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/maxrestweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml


## Replace web.xml for maximo-all mboweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/mboweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml


## Replace web.xml for maximo-all meaweb
WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-all/meaweb/webmodule/WEB-INF/
RUN mv web.xml web-oidc.xml
RUN mv web-dev.xml  web.xml

#WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default/config-deployment-descriptors/maximo-x/webmodule/WEB-INF/
#RUN mv web.xml web-oidc.xml
#RUN mv web-guest.xml  web-guest-oidc.xml
#RUN mv web-dev.xml  web.xml
#RUN mv web-guest-dev.xml  web-guest.xml

WORKDIR /opt/IBM/SMP/maximo/deployment/was-liberty-default
RUN ./maximo-all.sh

RUN echo "-Xmx8192m" >> /opt/IBM/SMP/maximo/deployment/was-liberty-default/deployment/maximo-all/maximo-all-server/jvm.options

FROM websphere-liberty:24.0.0.8-full-java8-ibmjava

COPY --chown=1001:0 --from=BASE /opt/IBM /opt/IBM/
COPY --chown=1001:0 --from=BASE /opt/IBM/SMP/maximo/deployment/was-liberty-default/deployment/maximo-all/maximo-all-server /config/
COPY --chown=1001:0 update-maximoproperties.sh /opt/IBM
COPY --chown=1001:0 updatedb-needed.sh /opt/IBM
COPY --chown=1001:0 docker-server.sh /opt/ibm/helpers/runtime/
COPY --chown=1001:0 server-custom.xml /config

RUN chmod a+x /opt/IBM/update-maximoproperties.sh

RUN configure.sh

#RUN sed -i -e "s/\(mxe.db.schemaowner\)=\(.*\)/\1=$MXE_DB_SCHEMAOWNER/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
#RUN sed -i -e "s/\(mxe.db.url\)=\(.*\)/\1=$MXE_DB_URL/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
#RUN sed -i -e "s/\(mxe.db.driver\)=\(.*\)/\1=$MXE_DB_DRIVER/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
#RUN sed -i -e "s/\(mxe.db.user\)=\(.*\)/\1=$MXE_DB_USER/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
#RUN sed -i -e "s/\(mxe.db.password\)=\(.*\)/\1=$MXE_DB_PASSWORD/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
#RUN sed -i "s/(mxe.db.schemaowner)=(.*)/$1=$MXE_SECURITY_OLD_CRYPTO_KEY/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
#RUN sed -i "s/(mxe.db.schemaowner)=(.*)/$1=$MXE_SECURITY_CRYPTO_KEY/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
#RUN sed -i "s/(mxe.db.schemaowner)=(.*)/$1=$MXE_SECURITY_OLD_CRYPTOX_KEY/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties
#RUN sed -i "s/(mxe.db.schemaowner)=(.*)/$1=$MXE_SECURITY_CRYPTOX_KEY/g" /opt/IBM/SMP/maximo/applications/maximo/properties/maximo.properties


ENV MXE_DB_SCHEMAOWNER=
ENV MXE_DB_URL=
ENV MXE_DB_DRIVER=
ENV MXE_SECURITY_OLD_CRYPTO_KEY=
ENV MXE_SECURITY_CRYPTO_KEY=
ENV MXE_SECURITY_OLD_CRYPTOX_KEY=
ENV MXE_SECURITY_CRYPTOX_KEY=
ENV MXE_DB_USER=maximo
ENV MXE_DB_PASSWORD=maximo
ENV MAXIMO_DATAFILE=maxdemo

