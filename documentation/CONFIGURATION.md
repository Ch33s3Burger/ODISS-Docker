# Configuration

| Name                                  | Description                                                                                                           |
|:--------------------------------------|:----------------------------------------------------------------------------------------------------------------------|
| ODISS_SERVER_NAME                     | The Server name (ex: example.com). Should be the same as used in your Certificates.                                   |
|                                       |                                                                                                                       |
| ODISS_DRUID_ADMIN_PASSWORD            | The Druid admin password. Which is used for login in into the Druid console and for authenticating over HTTP-Requests |
| ODISS_DRUID_DRUID_SYSTEM_PASSWORD     | Password for internal communication between processes.                                                                |
| ODISS_DRUID_INTERNAL_CLIENT_USERNAME  | Username for requests made as the internal system user.                                                               |
| ODISS_DRUID_INTERNAL_CLIENT_PASSWORD  | Password for requests made as the internal system user.                                                               |
| ODISS_DRUID_ZOOKEEPER_SERVER_USERNAME | The Zookeeper auth username for the Druid connection.                                                                 |
| ODISS_DRUID_ZOOKEEPER_SERVER_PASSWORD | The Zookeeper auth password for the Druid connection.                                                                 |
| ODISS_DRUID_LOG_LEVEL                 | The Log4j log level that should be used for all Druid applications.                                                   |
|                                       |                                                                                                                       |
| ODISS_KAFKA_KAFKACLIENT_USERNAME      |                                                                                                                       |
| ODISS_KAFKA_KAFKACLIENT_PASSWORD      |                                                                                                                       |
| ODISS_KAFKA_KAFKASERVER_USERNAME      | The Kafka Server admin username. Which is need by Druid to connect to a Kafka Topic. (username for external brokers)  |
| ODISS_KAFKA_KAFKASERVER_PASSWORD      | The Kafka Server admin password. Which is need by Druid to connect to a Kafka Topic. (password for external brokers)  |
| ODISS_KAFKA_CLIENT_USERNAME           | Username for SASL authentication with Zookeeper.                                                                      |
| ODISS_KAFKA_CLIENT_PASSWORD           | Password for SASL authentication with Zookeeper.                                                                      |
| ODISS_KAFKA_CERT_TYPE                 | The certificate type. Kafka only supports PEM or JKS certificates.                                                    |
| ODISS_KAFKA_KEYSTORE_FILE_NAME        | The file name of the Kafka Keystore.                                                                                  |
| ODISS_KAFKA_TRUSTSTORE_FILE_NAME      | The file name of the Kafka Truststore.                                                                                |
| ODISS_KAFKA_KEYSTORE_PASSWORD         | The password for the Keystore.                                                                                        |
| ODISS_KAFKA_KEY_PASSWORD              | The password for the Key.                                                                                             |
| ODISS_KAFKA_TRUSTSTORE_PASSWORD       | The password for the Truststore.                                                                                      |
|                                       |                                                                                                                       |
| ODISS_ZOOKEEPER_SERVER_USERNAME       | The Zookeeper Server admin username.                                                                                  |
| ODISS_ZOOKEEPER_SERVER_PASSWORD       | The Zookeeper Server admin password.                                                                                  |
| ODISS_ZOOKEEPER_LOG_LEVEL             | The Log4j log level that should be used for Zookeeper.                                                                |
|                                       |                                                                                                                       |
| ODISS_POSTGRES_USER                   | The Postgres admin username. Which is used by Druid to connect to Postgres.                                           |
| ODISS_POSTGRES_PASSWORD               | The Postgres admin password. Which is used by Druid to connect to Postgres.                                           |
|                                       |                                                                                                                       |
| ODISS_TRINO_USERNAME                  | The Trino admin username. Which is used by Metabase to connect to a Catalog.                                          |
| ODISS_TRINO_PASSWORD                  | The Trino admin password. Which is used by Metabase to connect to a Catalog.                                          |
| ODISS_TRINO_LOG_LEVEL                 | The Log4j log level that should be used for Trino.                                                                    |
|                                       |                                                                                                                       |
| ODISS_NGINX_CERT_FILE_NAME            | The file name of the Nginx certificate.                                                                               |
| ODISS_NGINX_KEY_FILE_NAME             | The file name of the Nginx cey.                                                                                       |
| <a name="metabase_config"></a>        |                                                                                                                       |
| ODISS_METABASE_ADMIN_EMAIL            | The admin account E-Mail.                                                                                             |
| ODISS_METABASE_ADMIN_FIRST_NAME       | The admin accounts first name.                                                                                        |
| ODISS_METABASE_ADMIN_LAST_NAME        | The admin account last name.                                                                                          |
| ODISS_METABASE_ADMIN_PASSWORD         | The admin account password.                                                                                           |
| ODISS_METABASE_LOG_LEVEL              | The Log4j log level that should be used for Metabase.                                                                 |
