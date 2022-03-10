# ODISS-Docker

## Installation

1. Clone the Repository

```
git clone https://github.com/Ch33s3Burger/ODISS-Docker.git
```

2. Edit the config under `env/dev.properties`

3. Run the `setup.sh` script.<a name="setup"></a>

```
sh setup.sh
```

4. Add or [Create](#CertCreation) the Kafka and Nginx Certificates.

5. Start the docker containers.

```
docker-compose up -d
```

The **Kafka** Certificate location is under `config/kafka/certs/`.

The **Nginx** Certificate location is under `config/nginx/certs/`.

The Certificates must be named after the definition in the config.

## Configuration

| Program   | Name                                  | Description   |
| :-------: | :------------------------------------ | :------------ |
|           | ODISS_SERVER_NAME                     | The Server name (ex: example.com). Should be the same as used in your Certificates. |
|           |                                       |  |
| Druid     | ODISS_DRUID_ADMIN_PASSWORD            | The Druid admin password. Which is used for login in into the Druid console and for authenicating over HTTP-Requests |
|           | ODISS_DRUID_DRUID_SYSTEM_PASSWORD     |  |
|           | ODISS_DRUID_INTERNAL_CLIENT_USERNAME  |  |
|           | ODISS_DRUID_INTERNAL_CLIENT_PASSWORD  |  |
|           | ODISS_DRUID_LOG_LEVEL                 | The Log4j log level that should be used for all Druid applications. |
|           |                                       |  |
| Kafka     | ODISS_KAFKA_KAFKACLIENT_USERNAME      |  |
|           | ODISS_KAFKA_KAFKACLIENT_PASSWORD      |  |
|           | ODISS_KAFKA_KAFKASERVER_USERNAME      | The Kafka Server admin username. Which is need by Druid to connect to a Kafka Topic. |
|           | ODISS_KAFKA_KAFKASERVER_PASSWORD      | The Kafka Server admin password. Which is need by Druid to connect to a Kafka Topic. |
|           | ODISS_KAFKA_CLIENT_USERNAME           |  |
|           | ODISS_KAFKA_CLIENT_PASSWORD           |  |
|           | ODISS_KAFKA_KEYSTORE_FILE_NAME        | The file name of the Kafka Keystore. |
|           | ODISS_KAFKA_TRUSTSTORE_FILE_NAME      | The file name of the Kafka Truststore. |
|           | ODISS_KAFKA_KEYSTORE_PASSWORD         | The password for the Keystore. |
|           | ODISS_KAFKA_KEY_PASSWORD              | The password for the Key. |
|           | ODISS_KAFKA_TRUSTSTORE_PASSWORD       | The password for the Truststore. |
|           |                                       |  |
| Zookeeper | ODISS_ZOOKEEPER_SERVER_USERNAME       | The Zookeeper Server admin username. |
|           | ODISS_ZOOKEEPER_SERVER_PASSWORD       | The Zookeeper Server admin password. |
|           | ODISS_ZOOKEEPER_SERVER_KAFKA_USERNAME | The Zookeeper auth username for the Kafka connection. |
|           | ODISS_ZOOKEEPER_SERVER_KAFKA_PASSWORD | The Zookeeper auth password for the Kafka connection. |
|           | ODISS_ZOOKEEPER_SERVER_DRUID_USERNAME | The Zookeeper auth username for the Druid connection. |
|           | ODISS_ZOOKEEPER_SERVER_DRUID_PASSWORD | The Zookeeper auth password for the Druid connection. |
|           | ODISS_ZOOKEEPER_LOG_LEVEL             | The Log4j log level that should be used for Zookeeper. |
|           |                                       |  |
| Postgres  | ODISS_POSTGRES_USER                   | The Postgres admin username. Which is used by Druid to connect to Postgres. |
|           | ODISS_POSTGRES_PASSWORD               | The Postgres admin password. Which is used by Druid to connect to Postgres. |
|           |                                       |  |
| Trino     | ODISS_TRINO_USERNAME                  | The Trino admin username. Which is used by Metabase to connect to a Catalog. |
|           | ODISS_TRINO_PASSWORD                  | The Trino admin password. Which is used by Metabase to connect to a Catalog. |
|           | ODISS_TRINO_LOG_LEVEL                 | The Log4j log level that should be used for Trino. |
|           |                                       |  |
| Nginx     | ODISS_NGINX_CERT_FILE_NAME            | The file name of the Nginx certificate.  |
|           | ODISS_NGINX_KEY_FILE_NAME             | The file name of the Nginx cey. |

## Self signed Certificate creation<a name="CertCreation"></a>

The [setup](#setup) script creates new scripts based on the config. These scripts are located in the `script/` folder.

### Kafka Certificate creation

Run the `kafka_cert_generator.sh` script from within the `script/` folder.

```
bash kafka_cert_generator.sh
```

### Nginx Certificate creation

Run the `nginx_cert_generator.sh` script from within the `script/` folder.

```
bash nginx_cert_generator.sh
```
