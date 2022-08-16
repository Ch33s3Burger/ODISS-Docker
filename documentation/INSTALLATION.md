# Installation

<a name="installation_single_server"></a>

## Single Server

The following installation guide describes the procedure to set up this project on a single machine. You can customize
the Apache Druid applications to fit the system size.

1. Clone the Repository

```
git clone https://github.com/Ch33s3Burger/ODISS-Docker.git
```

2. Edit the config under `env/dev.properties` (For details on the variables take a look at
   the [configuration settings](./CONFIGURATION.md))

3. Run the `setup.sh` script. With your chosen server size. </br>
   Possible options are: nano, micro, small, medium, large, xlarge

```
sh setup.sh nano
```

4. [Add](./CERTS.md) or [Create](./SCIPTS.md#self-signed-certificate-creation) the Kafka and Nginx Certificates.

5. Start the docker containers. (Execute in source folder)

```
docker-compose up -d
```

6. Setup Metabase. Run the ["Auto Metabase Setup"](./SCIPTS.md#auto-metabase-setup) script.