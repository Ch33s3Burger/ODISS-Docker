# ODISS-Docker

ODISS-Docker is project to connect different applications from the [Apache Software Foundation](https://www.apache.org/) with each other in a docker environment.
The main purpose is to store data in [Apache Druid](https://druid.apache.org/) which then can be accessed and analysed with [Apache Metabase](https://www.metabase.com/).
The data ingestion is performed through [Apache Kafka](https://kafka.apache.org/). </br>
The most important realization of this project is to automatically connect the application to each other without much manual configuration.
Therefore, this project contains some [scripts](./documentation/SCIPTS.md) that automatically distribute the credentials over the system from a config.
So the configuration is only necessary in one place. </br>
For development, there are also scripts available for the automatic creation of [self-signed certificates](./documentation/SCIPTS.md#self-signed-certificate-creation).

# Table of contents

* [Installation](./documentation/INSTALLATION.md)
* [Configuration](./documentation/CONFIGURATION.md)
* [Getting Started](./documentation/GETTING_STARTED_ADMIN.md)
* [Requirements](./documentation/REQUIREMENTS.md)
* [Architecture](./documentation/ARCHITECTURE.md)
* [Certificates](./documentation/CERTS.md)
* [Backups](./documentation/BACKUP_RESTORING.md)

