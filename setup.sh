#!/bin/bash

SERVER_SIZE=${1:-micro}

ENV=${2:-dev}

export $(grep -v '^#' ./env/${ENV}.properties | xargs)
export SERVER_SIZE

mkdir -p "./config/druid/single-server"

cp -R ./config_templates/kafka/. ./config/kafka
cp -R ./config_templates/metabase/. ./config/metabase
cp -R ./config_templates/nginx/. ./config/nginx
cp -R ./config_templates/trino/. ./config/trino
cp -R ./config_templates/zookeeper/. ./config/zookeeper


cp -R ./config_templates/druid/druid_supervisor_config/. ./config/druid/druid_supervisor_config
cp -R ./config_templates/druid/single-server/${SERVER_SIZE}/. ./config/druid/single-server/${SERVER_SIZE}

envsubst < docker-compose.yml.template > docker-compose.yml
envsubst < config_templates/druid/single-server/${SERVER_SIZE}/_common/common.runtime.properties > config/druid/single-server/${SERVER_SIZE}/_common/common.runtime.properties
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

envsubst < scripts/auto_kafka_ingestion.sh.template > scripts/auto_kafka_ingestion.sh
envsubst '${ODISS_SERVER_NAME} ${ODISS_METABASE_ADMIN_EMAIL} ${ODISS_METABASE_ADMIN_FIRST_NAME} ${ODISS_METABASE_ADMIN_LAST_NAME} ${ODISS_METABASE_ADMIN_PASSWORD} ${ODISS_TRINO_USERNAME}"}' < scripts/auto_metabase_setup.sh.template > scripts/auto_metabase_setup.sh
envsubst '${ODISS_NGINX_KEY_FILE_NAME} ${ODISS_NGINX_CERT_FILE_NAME}' < scripts/nginx_cert_generator.sh.template > scripts/nginx_cert_generator.sh
envsubst '${ODISS_KAFKA_KEYSTORE_FILE_NAME} ${ODISS_KAFKA_TRUSTSTORE_FILE_NAME}' < scripts/kafka_cert_generator.sh.template > scripts/kafka_cert_generator.sh

touch ./config/trino/password.db
htpasswd -b -B -C 10 ./config/trino/password.db ${ODISS_TRINO_USERNAME} ${ODISS_TRINO_PASSWORD}
