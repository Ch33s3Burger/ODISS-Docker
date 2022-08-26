# Installation

## Single Server

The following installation guide describes the procedure to set up this project on a single machine. You can customize
the Apache Druid applications to fit the system size.

1. Clone the Repository

```
git clone https://gitlab-imi.ukaachen.de/bdill/ODISS-Docker.git
```

2. Go into the ODISS-Docker directory

```
cd ODISS-Docker/
```

3. Edit the config under [env/dev.properties](../env/dev.properties) (For details on the variables take a look at
   the [configuration settings](./CONFIGURATION.md))

4. Run the `setup.sh` script. It will also start the docker-compose.</br>

    * `-s SERVER_SIZE` OPTIONS: nano (default), micro, small, medium, large, xlarge </br>
    * `-e ENVIRONMENT_FILE` Configuration File in folder `env/` default: `dev.properties`

   **a. Add your own certificates.**

    1. Run the `setup.sh` script.

      ```
      bash setup.sh
      ```

    2. Add the certs manually. The location and configurations you have to adjust are described [here](./CERTS.md).

    3. Rerun the `setup.sh` script. If you adjusted the [configuration settings](./CONFIGURATION.md) in between it will
       automatically update.

      ```
      bash setup.sh
      ```

   **b. Or generate test certificates with the setup script.**

   ```
   bash setup.sh -t
   ```

5. ODISS is now successfully set up. The Apache Druid, Apache Metabase and Trino links are printed out at the end of
   the `setup.sh` script.
   Now you can [get started](./GETTING_STARTED_ADMIN.md) with ODISS.