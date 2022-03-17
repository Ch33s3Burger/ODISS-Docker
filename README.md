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

## Architecture <a name="architecture"></a>

The default Kafka setup for this project has two different listeners. One is for internal communication which is **not** encypted and onyl

Doc still in progress!!!

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

7. (Optional) Add Kafka ingestion in Druid. Run the ["Auto Kafka Ingestion"](./scripts/SCIPTS.md#auto-metabase-setup) script to make Druid listen to the Kafka topics. This will automatically import new Data that has been added to the Kafka Streams.

## Getting started

The following tutorials will only scratch the surface of what you are able to do with this project.
Each program has its own documentation, to which is linked below.

 * Apache Druid: https://druid.apache.org/docs/latest/design/index.html
 * Apache Kafka: https://kafka.apache.org/documentation/
 * Apache Metabase: https://www.metabase.com/docs/latest/
 * Trino: https://trino.io/docs/current/

The next sections are about the process of importing data into Apache Druid via Apache Kafka streams.

### Load Data into Kafka

Kafka provides a [Java API](https://kafka.apache.org/documentation/#api) which added to every Java project with Maven. You just have to add the maven dependencies.
Since this tutorial is about loading data into Kafka the following section will only describe how to use the [Java Producer API](https://kafka.apache.org/documentation/#producerapi).
If you would like to import data over the terminal you can use the Kafka scripts described in the [Kafka Quickstart](https://kafka.apache.org/quickstart).

Independent of the import method it is necessary to use the right Kafka client properties.
Kafka is set up so that you have to authenticate via **SASL**. The connection is also encrypted over TLSv1.2.
For more details on the architecture take a look at the [architecture section](#architecture)
Therefore, the Kafka Client JAAS config and the Kafka Truststore is needed to establish the connection.

The Kafka Client properties can look like the following: `kafka.client.properties`.
You only have to replace the variables from the [configuration](#config).
<a name="kafkaclientproperties"></a>
```
# Standard Kafka config to connect to a Kafka server as a Client
# Authentication is over SASL_PLAIN
# The encryption is over TLSv1.2

# The Kafka connection URL
bootstrap.servers=${ODISS_SERVER_NAME}:9093

#
# SASL config
#

sasl.mechanism=PLAIN
security.protocol=SASL_SSL
ssl.protocol=TLSv1.2
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
   serviceName="kafka" \
   username="${ODISS_KAFKA_KAFKASERVER_USERNAME}" \
   password="${ODISS_KAFKA_KAFKASERVER_PASSWORD}";

# SSL config
ssl.truststore.location=path/to/kafka/truststore/location/${ODISS_KAFKA_TRUSTSTORE_FILE_NAME}
ssl.truststore.password=kafka_truststore_password

# If you are using a self signed certificate you have to add these config so that Kafka does not validate the certificate
enable.ssl.certificate.verification=false
ssl.endpoint.identification.algorithm=

# Kafka Stream design config
default.key.serde=org.apache.kafka.common.serialization.Serdes$StringSerde
default.value.serde=org.apache.kafka.common.serialization.Serdes$StringSerde
value.serializer=org.apache.kafka.common.serialization.StringSerializer
key.serializer=org.apache.kafka.common.serialization.IntegerSerializer
```

Maven dependency:
```
<dependency>
	<groupId>org.apache.kafka</groupId>
	<artifactId>kafka-clients</artifactId>
	<version>3.1.0</version>
</dependency>
```

Java method to integrate/import a JSONArray in a Kafka Topic. 
The JSONObjects in the JSONArray are not allowed to holder deeper JSON structure like another JSONArray.
It is only allowed to look like the following example.
`{"Username":"Admin","Password":"admin_password","Age":34,"UserGroup":"AdminGroup"}`
You can always adjust your import format, but it has to be a supported [data format](https://druid.apache.org/docs/latest/ingestion/data-formats.html) by Druid.
This also requires the `org.json` dependency.
```
<dependency>
   <groupId>org.json</groupId>
   <artifactId>json</artifactId>
   <version>20210307</version>
</dependency>
```

The following method creates a KafkaProducer with the `properties` loaded from the [Kafka Client properties](#kafkaclientproperties).
Then it sends a ProducerRecord for each entry in the JSONArray.
Each ProducerRecord has its own key which is `value.hashCode()` in this example and the value is the JSONObject as a String.
In result the Kafka stream with the Topic name `streamTopicName` holds the data from the JSONArray in a valid format that can be interpreted by Druid.

```
public void integrateIntoStream(String streamTopicName, JSONArray data) {
   final Properties properties = new Properties();
   
   // Load the Kafka Client propeties: here from the Resource folder as a InputStream.
   properties.load(KafkaStreamIntegrator.class.getResourceAsStream("/kafka.client.properties"));

   Producer<Integer, String> producer = new KafkaProducer<>(properties);
   
   IntStream.range(0, data.length())
          .mapToObj(data::getJSONObject)
          .forEach(value -> producer.send(
                  new ProducerRecord<>(streamTopicName, value.hashCode(), value.toString())
          ));
   producer.close();
}
```

The following section explains how you can import the just filled Kafka Stream into Druid by using the Druid Console.

### Load Data (from Kafka)

Apache Druid is your Data Warehouse which holds all the data in segments. 
The data is imported over Ingestion specs which define how Druid reads and stores it. 
You can write ingestion specs by hand. Or you can use the data loader.
The following section describes how you can define the Ingestion specs for a Kafka stream Ingestion.
Other Ingestion methods are described in the [Druid documentation](https://druid.apache.org/docs/latest/design/index.html).

This tutorial will refer to the [official Druid tutorial](https://druid.apache.org/docs/latest/tutorials/tutorial-kafka.html#loading-data-with-the-data-loader) 
and adjust their tutorial to this project.

1. Navigate to the Druid Console under `https://example.com/`. Replace `example.com` with your `ODISS_SERVER_NAME`.


   ![Druid_console_load_data_ingestion_method](instruction_material/Druid_console_load_data_ingestion_method.png)

2. After choosing Apache Kafka as the Ingestion method and clicking on "Connect data" you have to adjust the connection parameters.


   ![Druid_console_load_data_kafka_connect](instruction_material/Druid_console_load_data_kafka_connect.png)

On the right side you have to configure the [Kafka Topic](https://kafka.apache.org/intro) which is esentially the stream ID from which you would like to import your data from.
Since Kafka is secured by authentication you have to adjust the `Consumer properties`. 
The following can be copied and replace the variables with definition from the [Configuration](#config).

```
{
  "bootstrap.servers": "kafka:9092",
  "security.protocol": "SASL_PLAINTEXT",
  "sasl.mechanism": "PLAIN",
  "sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required \
      username='$ODISS_KAFKA_KAFKASERVER_USERNAME' \
      password='$ODISS_KAFKA_KAFKASERVER_PASSWORD';"
}
```

After clicking "Apply" Druid tries to establish the connection to Kafka with the given authentication config.
If you have adjusted your Kafka Jaas config the `Consumer properties` may differ.

3. When the connection to the [Kafka Topic](https://kafka.apache.org/intro) is made you should already see you unparsed data.
   Once the data is located, you can click "Next: Parse data" to go to the next step.

4. The following steps does not differ from the [official Druid tutorial](https://druid.apache.org/docs/latest/tutorials/tutorial-kafka.html#loading-data-with-the-data-loader).
   Therefore, just follow the Druid tutorial from the third step (Parse data).

### How to access the Data from external Clients

There are APIs in Druid or Metabase to load the data into external programs. 
(Suggestion: Use the Druid APIs since they directly access the data, and you do not have to publish your data publicly.)

Druid has a Python API called [pydruid](https://github.com/druid-io/pydruid) and a R API called [RDruid](https://github.com/druid-io/RDruid),
but they are both not supported anymore. </br>
Druid also provides a [HTTP API](https://druid.apache.org/docs/latest/operations/api-reference.html) which allows complete control about managing the data. 
To query the data with SQL you can connect to the Avatica JDBC driver interface.
There is a [complete documentation](https://druid.apache.org/docs/latest/querying/sql.html#jdbc) on how to connect to the interface.
The only thing that differ is the URL. First, you can only access it over HTTPS and you have to add your basic auth credentials. 
It should look something like the following. Only replace the variables with definition from the [Configuration](#config).
```
jdbc:avatica:remote:url=https://admin:${ODISS_DRUID_ADMIN_PASSWORD}@${ODISS_SERVER_NAME}/druid/v2/sql/avatica/

jdbc:avatica:remote:url=https://admin:admin_password@localhost/druid/v2/sql/avatica/
```
You can also query the data over [HTTP POST requests](https://druid.apache.org/docs/latest/querying/sql.html#http-post) if you are not able to use the JDBC driver.
In R you can get and parse the data with the following script. You need to install the 3 libraries imported at the top of the script. 
The request URL is very similar to the URL for the JDBC driver. here you also have to replace the variables with definition from the [Configuration](#config).
```
library(tidyverse)
library(httr)
library(jsonlite)

data <- POST(
  'https://admin:${ODISS_DRUID_ADMIN_PASSWORD}@${ODISS_SERVER_NAME}/druid/v2/sql/',
  body = list(query = 'SELECT * FROM INFORMATION_SCHEMA.TABLES'),
  config = httr::config(ssl_verifypeer = FALSE),
  encode = 'json'
) %>%
  content(as = 'text', encoding = 'UTF-8') %>%
  fromJSON()
```

In Metabase you can define [Questions](https://www.metabase.com/docs/latest/users-guide/04-asking-questions.html) (SQL Queries) and save them. 
To access the results you have to [publish the question](https://www.metabase.com/docs/latest/administration-guide/12-public-links.html). 
This returns a URL with a generated ID for that question. Over the URL you can get the data with a HTTP get request. 
**But this URL is not secured over authentication, so it is publicly accessible if you have the question ID.**

### How to access the Data using internal Tools

You can query the data using Metabase or the Druid Console. 
(Suggestion: Use Metabase instead of the Druid console, as Metabase is designed to query, manage and combine queries into dashboards.)

Doc still in progress!!!


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