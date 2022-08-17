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

3. Run the `setup.sh` script. </br>
   
   * `-s SERVER_SIZE` OPTIONS: nano (default), micro, small, medium, large, xlarge </br>
   * `-e ENVIRONMENT_FILE` Configuration File in folder `env/` default: `dev.properties`

   a. Generate test certificates with the setup script.

   ```
   bash setup.sh
   ```

   b. Add your own certificates.

      1. Run the `setup.sh` script.

      ```
      bash setup.sh -c
      ```
      
      2. Add the certs manually. The location and configurations you have to adjust are described [here](./CERTS.md).

      3. Rerun the `setup.sh` script.

      ```
      bash setup.sh -c
      ```