# ODISS-Docker

## Requirements

The software requirements for the installation machine are:

 * Linux, Mac OS X, or other Unix-like OS (Windows is not supported)
 * Java 8, Update 92 or later (8u92+)

Before installing in production, be sure to run it under a user with limited rights.
This is important because the Druid Console user will have, effectively, the same permissions as that user.

### Single Server 

The single server Apache Druid applications can be setup in 6 different sizes.
Each size has different requirements for the system. The smallest one is the **nano** configuration.
And the biggest one is the **xlarge** configuration.</br>
The **small, medium, large** and **xlarge** configurations are intended for general use single-machine deployments. 
They are sized for hardware roughly based on Amazon's i3 series of EC2 instances.</br>
For more detail regarding the Single Server deployment of Druid take a look at their [documentation](https://druid.apache.org/docs/latest/operations/single-server.html).

#### System requirements for each configuration

 * Nano: 1 CPU, 4GiB RAM
 * Micro: 4 CPU, 16GiB RAM
 * Small: 8 CPU, 64GiB RAM (~i3.2xlarge)
 * Medium: 16 CPU, 128GiB RAM (~i3.4xlarge)
 * Large: 32 CPU, 256GiB RAM (~i3.8xlarge)
 * X-Large: 64 CPU, 512GiB RAM (~i3.16xlarge)

## Installation

### Single Server

The following installation guide discribes the procedure to setup this project on a single machine.
You can customize the Apache Druid applications to fit the system size.


1. Clone the Repository

```
git clone https://github.com/Ch33s3Burger/ODISS-Docker.git
```

2. Edit the config under `env/dev.properties` (For details on the variables take a look at
   the [configuration settings](#config))

3. Run the `setup.sh` script. With your chosen server size. </br>
   Possible options are: nano, micro, small, medium, large, xlarge

```
sh setup.sh micro
```

4. [Add](#certs) or [Create](./scripts/SCIPTS.md#self-signed-certificate-creation) the Kafka and Nginx Certificates.

5. Start the docker containers.

```
docker-compose up -d
```

6. Setup Metabase. Run the ["Auto Metabase Setup"](./scripts/SCIPTS.md#auto-kafka-ingestion)

7. Add Kafka ingestion in Druid. Run the ["Auto Kafka Ingestion"](./scripts/SCIPTS.md#auto-metabase-setup) script to make Druid listen to the Kafka topics. This will automatically import new Data that has been added to the Kafka Streams.

## Configuration <a name="config"></a>

| Name                                  | Description                                                                                                          |
|:--------------------------------------|:---------------------------------------------------------------------------------------------------------------------|
| ODISS_SERVER_NAME                     | The Server name (ex: example.com). Should be the same as used in your Certificates.                                  |
|                                       |                                                                                                                      |
| ODISS_DRUID_ADMIN_PASSWORD            | The Druid admin password. Which is used for login in into the Druid console and for authenicating over HTTP-Requests |
| ODISS_DRUID_DRUID_SYSTEM_PASSWORD     |                                                                                                                      |
| ODISS_DRUID_INTERNAL_CLIENT_USERNAME  |                                                                                                                      |
| ODISS_DRUID_INTERNAL_CLIENT_PASSWORD  |                                                                                                                      |
| ODISS_DRUID_LOG_LEVEL                 | The Log4j log level that should be used for all Druid applications.                                                  |
|                                       |                                                                                                                      |
| ODISS_KAFKA_KAFKACLIENT_USERNAME      |                                                                                                                      |
| ODISS_KAFKA_KAFKACLIENT_PASSWORD      |                                                                                                                      |
| ODISS_KAFKA_KAFKASERVER_USERNAME      | The Kafka Server admin username. Which is need by Druid to connect to a Kafka Topic.                                 |
| ODISS_KAFKA_KAFKASERVER_PASSWORD      | The Kafka Server admin password. Which is need by Druid to connect to a Kafka Topic.                                 |
| ODISS_KAFKA_CLIENT_USERNAME           |                                                                                                                      |
| ODISS_KAFKA_CLIENT_PASSWORD           |                                                                                                                      |
| ODISS_KAFKA_CERT_TYPE                 | The certificate type. Kafka only supports PEM or JKS certificates.                                                   |
| ODISS_KAFKA_KEYSTORE_FILE_NAME        | The file name of the Kafka Keystore.                                                                                 |
| ODISS_KAFKA_TRUSTSTORE_FILE_NAME      | The file name of the Kafka Truststore.                                                                               |
| ODISS_KAFKA_KEYSTORE_PASSWORD         | The password for the Keystore.                                                                                       |
| ODISS_KAFKA_KEY_PASSWORD              | The password for the Key.                                                                                            |
| ODISS_KAFKA_TRUSTSTORE_PASSWORD       | The password for the Truststore.                                                                                     |
|                                       |                                                                                                                      |
| ODISS_ZOOKEEPER_SERVER_USERNAME       | The Zookeeper Server admin username.                                                                                 |
| ODISS_ZOOKEEPER_SERVER_PASSWORD       | The Zookeeper Server admin password.                                                                                 |
| ODISS_ZOOKEEPER_SERVER_KAFKA_USERNAME | The Zookeeper auth username for the Kafka connection.                                                                |
| ODISS_ZOOKEEPER_SERVER_KAFKA_PASSWORD | The Zookeeper auth password for the Kafka connection.                                                                |
| ODISS_ZOOKEEPER_SERVER_DRUID_USERNAME | The Zookeeper auth username for the Druid connection.                                                                |
| ODISS_ZOOKEEPER_SERVER_DRUID_PASSWORD | The Zookeeper auth password for the Druid connection.                                                                |
| ODISS_ZOOKEEPER_LOG_LEVEL             | The Log4j log level that should be used for Zookeeper.                                                               |
|                                       |                                                                                                                      |
| ODISS_POSTGRES_USER                   | The Postgres admin username. Which is used by Druid to connect to Postgres.                                          |
| ODISS_POSTGRES_PASSWORD               | The Postgres admin password. Which is used by Druid to connect to Postgres.                                          |
|                                       |                                                                                                                      |
| ODISS_TRINO_USERNAME                  | The Trino admin username. Which is used by Metabase to connect to a Catalog.                                         |
| ODISS_TRINO_PASSWORD                  | The Trino admin password. Which is used by Metabase to connect to a Catalog.                                         |
| ODISS_TRINO_LOG_LEVEL                 | The Log4j log level that should be used for Trino.                                                                   |
|                                       |                                                                                                                      |
| ODISS_NGINX_CERT_FILE_NAME            | The file name of the Nginx certificate.                                                                              |
| ODISS_NGINX_KEY_FILE_NAME             | The file name of the Nginx cey.                                                                                      |
| <a name="metabase_config"></a>        |                                                                                                                      |
| ODISS_METABASE_ADMIN_EMAIL            | The admin account E-Mail with which you have setup Metabase.                                                         |
| ODISS_METABASE_ADMIN_PASSWORD         | The admin account password with which you have setup Metabase.                                                       |
| ODISS_METABASE_LOG_LEVEL              | The Log4j log level that should be used for Metabase.                                                                |

## Add Certificates for Nginx and Kafka <a name="certs"></a>

### Kafka Certificate

The Kafka certificate is located in the `./config/kafka/certs/` folder. Kafka needs a Keystore with a valid key within
and a Truststore. As default the certificates are from type `JKS`. If you would like to used `PEM` certificates you can
adjust the `ODISS_KAFKA_CERT_TYPE` variable.

The files should be named like defined in the `ODISS_KAFKA_KEYSTORE_FILE_NAME` and `ODISS_KAFKA_TRUSTSTORE_FILE_NAME`
variables.

Both files can be genereated for testing with the [Kafka Certificate generator](./scripts/SCIPTS.md) script.

### Nginx Certificate

The Nginx certificate is located in the `./config/nginx/certs/` folder. Nginx needs a `.crt` file and a `.key` file.

The files should be named like defined in the `ODISS_NGINX_CERT_FILE_NAME` and `ODISS_NGINX_KEY_FILE_NAME` variables.

## Scripts

There are 5 scripts for helping to setup the project. The most important on is the `setup script` which sets up
the `docker-compose.yml` file and the config definitions for each container. Two additional scripts can help you for
connecting the container with each other. The last two scripts can be used to create your self signed certificates for
Nginx and Kafka.

For more information about the scripts and how to execute them look into the [SCRIPTS.md](./scripts/SCIPTS.md)
documentation.

Both files can be genereated for testing with the [Nginx Certificate generator](./scripts/SCIPTS.md) script.

## Backups

Since all applications run as Docker containers a backup can be done by following the [official docker guidelines](https://docs.docker.com/desktop/backup-and-restore/).
Overall only Metabase and Druid contain valuable data. Druid holds the data in seven different volumes. 
Each container has its own volume. The metadata is saved in postgres in the "metadata_data" volume.
And the data is saved in the "druid_shared" volume. The remaining volumes contain more temporary metadata. </br>
Metabase uses a local database which is located in the "metabase_data" volume. </br>
In conclusion for backing up this project you should save all volumes as images. 
And for restoring it you just have to reload those images like described in the [official docker guidelines](https://docs.docker.com/desktop/backup-and-restore/).