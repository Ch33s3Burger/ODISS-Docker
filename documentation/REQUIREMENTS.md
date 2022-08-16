# Requirements

The software requirements for the installation machine are:

* Linux, Mac OS X, or other Unix-like OS (Windows is not supported)
* [Java 8](https://docs.datastax.com/en/jdk-install/doc/jdk-install/installOpenJdkDeb.html), Update 92 or later (8u92+)
* [Docker](https://docs.docker.com/engine/install/ubuntu/) and [Docker-Compose](https://docs.docker.com/compose/install/)

Before installing in production, be sure to [run it under a user with limited rights](https://docs.docker.com/engine/install/linux-postinstall/).
This is important because the Druid Console user will have, effectively, the same permissions as that user.

## Single Server

The single server Apache Druid applications can be setup in 6 different sizes. Each size has different requirements for
the system. The smallest one is the **nano** configuration. And the biggest one is the **xlarge** configuration.</br>
The **small, medium, large** and **xlarge** configurations are intended for general use single-machine deployments. They
are sized for hardware roughly based on Amazon's i3 series of EC2 instances.</br>
For more detail regarding the Single Server deployment of Druid take a look at
their [documentation](https://druid.apache.org/docs/latest/operations/single-server.html).

### System requirements for each configuration Druid configuration

* Nano: 1 CPU, 4GiB RAM
* Micro: 4 CPU, 16GiB RAM
* Small: 8 CPU, 64GiB RAM (~i3.2xlarge)
* Medium: 16 CPU, 128GiB RAM (~i3.4xlarge)
* Large: 32 CPU, 256GiB RAM (~i3.8xlarge)
* X-Large: 64 CPU, 512GiB RAM (~i3.16xlarge)

Since there is also Apache Metabase, Apache Kafka and Trino you have to add up to 3GiB RAM. </br>
Depending on your size it is recommended to add multiple Trino worker for faster Querying from Apache Metabase.
If your data ingestion is also increasing you can also add multiple Apache Kafka applications.