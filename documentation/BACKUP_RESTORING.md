<a name="backups"></a>
# Backups

There are only three data locations that need to be backed up.</br>
The **Druid Segments** with the related metadata. The **Druid Segments** are located in the "druid_shared" volume which is mounted to `/opt/shared`.
The Druid metadata is saved in the seperated metadata-storage. In our case Postgres. </br>
The last data that has to be saved is the **Metabase database** which holds all the data used in Metabase.

To back up all the Data you can use the `backup.sh` script. Just run the script *while the program is running* with the following command. (From source root)

```
sh scripts/backup.sh
```

This script will create a folder `backup/` in the folder from the script has been executed. </br>
It will output three files. The `druid_metadata_dump.sql` which holds a Postgres dump of the Druid metadata.
A `druid_shared.tar` file which holds the zipped Druid segments (the data). And a `metabase_data.tar` which hold the metabase data.

# Restoring a Backup

As there are three location to back up there are also three to restore.
But if you prefer you can leave out the Metabase database. This gives you the opportunity to reset your Metabase.
If you leave out one of the other parts the restoring will not be successful. </br>

The requirements for the execution of the script are that the `backup/` folder exists with the 2-3 files
(`druid_metadata_dump.sql`, `druid_shared.tar` and optional `metabase_data.tar`) that will be created by the backup script.</br>
The script will also directly start the program. So you do **not** have to run `docker-compose up -d` afterwards.

To restore a backup just execute the `restore.sh` script with teh following command. (From source root)</br>
If the script does not exist yet then execute the setup script first (`sh setup.sh`).

```
sh scripts/restore.sh
```

After the program started you should see the restored data in the Druid Console under the datasource section (`https://${ODISS_SERVER_NAME}/unified-console.html#datasources`).
If the data has not been imported correctly you should see the datasource from your backup with full availability.</br>

## Problems (Restoring)

If the datasource's are **not** shown in your Druid console there are two possible problems.
In both problems the metadata has not been restored successfully. You can check if the data restoring was successful by checking the `/opt/shared` folder in the "historical" container.
You can access to container with the following command:

```
docker exec -it historical /bin/sh
```

This opens a console inside the "historical" docker container. Now you read the content of the `/opt/shared` folder with the following command:

```
ls -h /opt/shared
```

If the result looks like the following the data import was successful then you only have to check the metadata.

```
indexing-logs segments
```

If the datasource's are shown in your Druid console, but they are not fully available then your data (segment) import failed.
The metadata indicates that there had been datasource's, but they can not find them in the defined location of the metadata.
If you can not restore the data from a backup you can just reingest the data with Kafka. If the data is *similar* to the old data it will be fully available again.</br>
Careful the metadata only the meta information about the segment not about the data inside.
Therefore, only information like the segment ID is compared which holds the Kafka Stream topic and the time span of the data.
