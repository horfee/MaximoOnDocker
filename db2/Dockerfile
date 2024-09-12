FROM icr.io/db2_community/db2

RUN mkdir /var/custom
COPY *.sh /var/custom
COPY healthcheck /var/healthcheck.sh
RUN chmod a+x /var/healthcheck.sh
RUN chmod a+x /var/custom/*.sh
