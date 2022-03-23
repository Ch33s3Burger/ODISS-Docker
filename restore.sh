docker-compose up -d postgres

/bin/sleep 3

docker exec -i postgres /bin/bash -c "PGPASSWORD=FoolishPassword psql --username druid druid" < ./backup/druid_metadata_dump.sql
docker-compose up -d

/bin/sleep 10

docker run --rm --volumes-from middlemanager -v $(pwd):/a ubuntu bash -c "cd /opt/ && tar xvf /a/backup/druid_shared.tar --strip 1"