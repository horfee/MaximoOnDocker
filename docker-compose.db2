
services:
  database:
    container_name: database
    build: './db2'
    restart: unless-stopped
    privileged: true
    networks:
      - default
    ports:
      - '50000:50000'
    environment:
      - LICENSE=accept
      - DB2INSTANCE=db2inst1
      - DB2INST1_PASSWORD=maximo
      - DBNAME=maxdb9
      - SCHEMA_USERNAME=maximo
      - SCHEMA_PASSWORD=maximo
    volumes:
      - ./db2/data:/database
    healthcheck:
      test: ["CMD", "/var/healthcheck.sh"]
      start_period: 30s
      interval: 30s
      timeout: 10s
      retries: 100

  maximo:
    container_name: maximo
    build: './maximo'
    restart: unless-stopped
    depends_on:
      database:
        condition: service_healthy
    networks:
      - default
    ports:
      - '9080:9080'
    environment:
      - MXE_DB_URL=jdbc:db2://database:50000/maxdb9
      - MXE_DB_SCHEMAOWNER=maximo
      - MXE_DB_DRIVER=com.ibm.db2.jcc.DB2Driver
      - MXE_DB_USER=maximo
      - MXE_DB_PASSWORD=maximo
      - MAXIMO_DATAFILE=maxdemo
    volumes:
      - ./doclinks:/opt/IBM/doclinks
  
