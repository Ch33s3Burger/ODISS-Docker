curl -k -XPOST -H'Content-Type: application/json' -d @druid_supervisor_config/form.json https://localhost/coordinator/druid/indexer/v1/supervisor
curl -k -XPOST -H'Content-Type: application/json' -d @druid_supervisor_config/item.json https://localhost/coordinator/druid/indexer/v1/supervisor
curl -k -XPOST -H'Content-Type: application/json' -d @druid_supervisor_config/itemgroup.json https://localhost/coordinator/druid/indexer/v1/supervisor
curl -k -XPOST -H'Content-Type: application/json' -d @druid_supervisor_config/study.json https://localhost/coordinator/druid/indexer/v1/supervisor
curl -k -XPOST -H'Content-Type: application/json' -d @druid_supervisor_config/studyevent.json https://localhost/coordinator/druid/indexer/v1/supervisor
curl -k -XPOST -H'Content-Type: application/json' -d @druid_supervisor_config/subject.json https://localhost/coordinator/druid/indexer/v1/supervisor
curl -k -XPOST -H'Content-Type: application/json' -d @druid_supervisor_config/subjectentry.json https://localhost/coordinator/druid/indexer/v1/supervisor
curl -k -XPOST -H'Content-Type: application/json' -d @druid_supervisor_config/user.json https://localhost/coordinator/druid/indexer/v1/supervisor
