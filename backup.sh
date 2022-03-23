mkdir -p "./backup"

docker exec -i postgres /bin/bash -c "PGPASSWORD=FoolishPassword pg_dump --username druid druid" > ./backup/druid_metadata_dump.sql

docker run --rm --volumes-from middlemanager -v $(pwd):/a ubuntu tar cvf /a/backup/druid_shared.tar /opt/shared
docker run --rm --volumes-from metabase -v $(pwd):/a ubuntu tar cvf /a/backup/metabase_data.tar /tmp