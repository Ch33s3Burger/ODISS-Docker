#!/bin/bash

create_test_certs='False'
SERVER_SIZE='nano'
ENV='dev.properties'

while getopts 's:e:t' opt; do
  case $opt in
    t )
      create_test_certs='True';;
    s )
      SERVER_SIZE=$OPTARG;;
    e )
      ENV=$OPTARG;;
    ? )
      echo "script usage: $(basename \$0) [-s SERVER_SIZE] [-e ENVIRONMENT_FILE_NAME] [-t]" >&2
      exit 1
      ;;
  esac
done

export $(grep -v '^#' ./env/${ENV} | xargs)
export SERVER_SIZE

if [ "$ODISS_POSTGRES_USER" == 'metabase' ] || [ "$ODISS_POSTGRES_USER" == 'druid' ]; then
  echo "The ODISS_POSTGRES_USER varaible is not allowed to be named druid or metabase!"
  exit 1
fi

mkdir -p "./config/druid/single-server"

cp -R ./config_templates/kafka/. ./config/kafka
cp -R ./config_templates/metabase/. ./config/metabase
cp -R ./config_templates/nginx/. ./config/nginx
cp -R ./config_templates/trino/. ./config/trino
cp -R ./config_templates/zookeeper/. ./config/zookeeper
cp -R ./config_templates/postgres/. ./config/postgres


cp -R ./config_templates/druid/druid_supervisor_config/. ./config/druid/druid_supervisor_config
cp -R ./config_templates/druid/single-server/${SERVER_SIZE}/. ./config/druid/single-server/${SERVER_SIZE}

envsubst < docker-compose.yml.template > docker-compose.yml
envsubst < config_templates/druid/single-server/${SERVER_SIZE}/_common/common.runtime.properties > config/druid/single-server/${SERVER_SIZE}/_common/common.runtime.properties
envsubst < config_templates/druid/consumer_properties.txt.template > config/druid/consumer_properties.txt
envsubst < config_templates/kafka/kafka.client.properties.template > config/kafka/kafka.client.properties
envsubst < config_templates/kafka/kafka_jaas.conf > config/kafka/kafka_jaas.conf
envsubst < config_templates/kafka/server.properties > config/kafka/server.properties
envsubst < config_templates/kafka/log4j.properties > config/kafka/log4j.properties
envsubst < config_templates/nginx/nginx.conf > config/nginx/nginx.conf
envsubst < config_templates/trino/catalog/druid.properties > config/trino/catalog/druid.properties
envsubst < config_templates/trino/log.properties > config/trino/log.properties
envsubst < config_templates/zookeeper/zoo.cfg > config/zookeeper/zoo.cfg
envsubst < config_templates/zookeeper/zookeeper_jaas.conf > config/zookeeper/zookeeper_jaas.conf
envsubst < config_templates/metabase/log4j2.xml > config/metabase/log4j2.xml

envsubst < config_templates/druid/druid_supervisor_config/form.json > config/druid/druid_supervisor_config/form.json
envsubst < config_templates/druid/druid_supervisor_config/item.json > config/druid/druid_supervisor_config/item.json
envsubst < config_templates/druid/druid_supervisor_config/itemgroup.json > config/druid/druid_supervisor_config/itemgroup.json
envsubst < config_templates/druid/druid_supervisor_config/study.json > config/druid/druid_supervisor_config/study.json
envsubst < config_templates/druid/druid_supervisor_config/studyevent.json > config/druid/druid_supervisor_config/studyevent.json
envsubst < config_templates/druid/druid_supervisor_config/subject.json > config/druid/druid_supervisor_config/subject.json
envsubst < config_templates/druid/druid_supervisor_config/subjectentry.json > config/druid/druid_supervisor_config/subjectentry.json
envsubst < config_templates/druid/druid_supervisor_config/user.json > config/druid/druid_supervisor_config/user.json

mkdir -p "./scripts/"

envsubst '${ODISS_DRUID_ADMIN_PASSWORD} ${ODISS_SERVER_NAME}' < scripts_template/auto_kafka_ingestion.sh.template > scripts/auto_kafka_ingestion.sh
envsubst < scripts_template/backup.sh.template > scripts/backup.sh
envsubst < scripts_template/restore.sh.template > scripts/restore.sh
envsubst '${ODISS_SERVER_NAME} ${ODISS_METABASE_ADMIN_EMAIL} ${ODISS_METABASE_ADMIN_FIRST_NAME} ${ODISS_METABASE_ADMIN_LAST_NAME} ${ODISS_METABASE_ADMIN_PASSWORD} ${ODISS_TRINO_USERNAME}"}' < scripts_template/auto_metabase_setup.sh.template > scripts/auto_metabase_setup.sh
envsubst '${ODISS_NGINX_KEY_FILE_NAME} ${ODISS_NGINX_CERT_FILE_NAME} ${ODISS_SERVER_NAME}' < scripts_template/nginx_cert_generator.sh.template > scripts/nginx_cert_generator.sh
envsubst '${ODISS_KAFKA_KEYSTORE_FILE_NAME} ${ODISS_KAFKA_TRUSTSTORE_FILE_NAME}, ${ODISS_SERVER_NAME} ${ODISS_KAFKA_KEYSTORE_PASSWORD} ${ODISS_KAFKA_TRUSTSTORE_PASSWORD}' < scripts_template/kafka_cert_generator.sh.template > scripts/kafka_cert_generator.sh

touch ./config/trino/password.db
htpasswd -b -B -C 10 ./config/trino/password.db ${ODISS_TRINO_USERNAME} ${ODISS_TRINO_PASSWORD}

if [ "$create_test_certs" == 'False' ]; then
  echo "Would you like to generate the Kafka and Nginx development (test) certs? [y/N]"
  read generate_certs
else
  generate_certs="y"
fi

if [ "$generate_certs" == "y" ]; then
  bash scripts/kafka_cert_generator.sh -f
  bash scripts/nginx_cert_generator.sh -f
  echo
  echo "The Kafka and Nginx development (test) certs have been created"
else
  mkdir -p ./config/kafka/certs/
  mkdir -p ./config/nginx/certs/
fi

kafka_keystore_location="./config/kafka/certs/"${ODISS_KAFKA_KEYSTORE_FILE_NAME}
kafka_truststore_location="./config/kafka/certs/"${ODISS_KAFKA_TRUSTSTORE_FILE_NAME}

if [ -e "$kafka_keystore_location" ] && [ -e "$kafka_truststore_location" ]; then
  if [ "$generate_certs" != "y" ]; then
    echo "The Kafka keystore and truststore already exist."
  fi
  kafka_certs_exist="True"
else
  echo "Add or generate the Kafka keystore and truststore."
fi

nginx_cert_location="./config/nginx/certs/"${ODISS_NGINX_CERT_FILE_NAME}
nginx_key_location="./config/nginx/certs/"${ODISS_NGINX_KEY_FILE_NAME}

if [ -e "$nginx_cert_location" ] && [ -e "$nginx_key_location" ]; then
  if [ "$generate_certs" != "y" ]; then
    echo "The Nginx cert and key file already exist."
  fi
  nginx_certs_exist="True"
else
  echo "Add or generate the Nginx cert and key file."
fi

if [ "$kafka_certs_exist" == "True" ] && [ "$nginx_certs_exist" == "True" ]; then
  docker-compose up -d

  echo "Waiting until everything has started (1m)"
  sleep 1m
  bash scripts/auto_metabase_setup.sh

  echo
  echo "Would you like to automatically add the ingestion config, which configures the ingestion from Kafka to Druid.[y/N]"
  read generate_kafka_druid_ingestion
  if [ "$generate_kafka_druid_ingestion" == "y" ]; then
    bash scripts/auto_kafka_ingestion.sh
    echo
    echo "The ingestions have been configured."
  fi

  echo "ODISS Started!"
  echo "You can reach Apache Druid under https://${ODISS_SERVER_NAME}."
  echo "You can reach Apache Metabase under https://${ODISS_SERVER_NAME}/metabase/."
  echo "You can reach Trino under https://${ODISS_SERVER_NAME}/trino/."
else
  echo "The certs are missing or they have not been configured correctly."
  echo -n "If you would like to add the certs manually. Just follow the instructions for adding the certs and restart the script. "
  echo "The ./config folder is already created."
fi