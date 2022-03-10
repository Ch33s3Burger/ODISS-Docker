#!/bin/bash

ENV=${1:-dev}

export $(grep -v '^#' ./env/${ENV}.properties | xargs)

cp -R ./config_templates/. ./config

envsubst < docker-compose.yml.template > docker-compose.yml
envsubst < config_templates/druid/environment > config/druid/environment
envsubst < config_templates/kafka/kafka_jaas.conf > config/kafka/kafka_jaas.conf
envsubst < config_templates/kafka/server.properties > config/kafka/server.properties
envsubst < config_templates/nginx/nginx.conf > config/nginx/nginx.conf
envsubst < config_templates/trino/catalog/mpn.properties > config/trino/catalog/mpn.properties
envsubst < config_templates/trino/log.properties > config/trino/log.properties
envsubst < config_templates/zookeeper/zoo.cfg > config/zookeeper/zoo.cfg
envsubst < config_templates/zookeeper/zookeeper_jaas.conf > config/zookeeper/zookeeper_jaas.conf

envsubst < config_templates/druid/druid_supervisor_config/form.json > config/druid/druid_supervisor_config/form.json
envsubst < config_templates/druid/druid_supervisor_config/item.json > config/druid/druid_supervisor_config/item.json
envsubst < config_templates/druid/druid_supervisor_config/itemgroup.json > config/druid/druid_supervisor_config/itemgroup.json
envsubst < config_templates/druid/druid_supervisor_config/study.json > config/druid/druid_supervisor_config/study.json
envsubst < config_templates/druid/druid_supervisor_config/studyevent.json > config/druid/druid_supervisor_config/studyevent.json
envsubst < config_templates/druid/druid_supervisor_config/subject.json > config/druid/druid_supervisor_config/subject.json
envsubst < config_templates/druid/druid_supervisor_config/subjectentry.json > config/druid/druid_supervisor_config/subjectentry.json
envsubst < config_templates/druid/druid_supervisor_config/user.json > config/druid/druid_supervisor_config/user.json

envsubst < scripts/auto_kafka_ingestion.sh.template > scripts/auto_kafka_ingestion.sh
envsubst < scripts/nginx_cert_generator.sh.template > scripts/nginx_cert_generator.sh
envsubst < scripts/kafka_cert_generator.sh.template > scripts/kafka_cert_generator.sh

touch ./config/trino/password.db
htpasswd -b -B -C 10 ./config/trino/password.db ${ODISS_TRINO_USERNAME} ${ODISS_TRINO_PASSWORD}
