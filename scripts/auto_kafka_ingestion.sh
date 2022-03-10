curl -u admin:password1 -k -XPOST -H'Content-Type: application/json' -d @../config/druid/druid_supervisor_config/form.json https://137.226.147.150/coordinator/druid/indexer/v1/supervisor
curl -u admin:password1 -k -XPOST -H'Content-Type: application/json' -d @../config/druid/druid_supervisor_config/item.json https://137.226.147.150/coordinator/druid/indexer/v1/supervisor
curl -u admin:password1 -k -XPOST -H'Content-Type: application/json' -d @../config/druid/druid_supervisor_config/itemgroup.json https://137.226.147.150/coordinator/druid/indexer/v1/supervisor
curl -u admin:password1 -k -XPOST -H'Content-Type: application/json' -d @../config/druid/druid_supervisor_config/study.json https://137.226.147.150/coordinator/druid/indexer/v1/supervisor
curl -u admin:password1 -k -XPOST -H'Content-Type: application/json' -d @../config/druid/druid_supervisor_config/studyevent.json https://137.226.147.150/coordinator/druid/indexer/v1/supervisor
curl -u admin:password1 -k -XPOST -H'Content-Type: application/json' -d @../config/druid/druid_supervisor_config/subject.json https://137.226.147.150/coordinator/druid/indexer/v1/supervisor
curl -u admin:password1 -k -XPOST -H'Content-Type: application/json' -d @../config/druid/druid_supervisor_config/subjectentry.json https://137.226.147.150/coordinator/druid/indexer/v1/supervisor
curl -u admin:password1 -k -XPOST -H'Content-Type: application/json' -d @../config/druid/druid_supervisor_config/user.json https://137.226.147.150/coordinator/druid/indexer/v1/supervisor
