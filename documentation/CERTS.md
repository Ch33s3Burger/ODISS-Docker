<a name="certs"></a>
## Add Certificates for Nginx and Kafka

<a name="kafka_certs"></a>
### Kafka Certificate

The Kafka certificate is located in the `./config/kafka/certs/` folder. Kafka needs a Keystore with a valid key within
and a Truststore. As default the certificates are from type `JKS`. If you would like to used `PEM` certificates you can
adjust the `ODISS_KAFKA_CERT_TYPE` variable.

The files should be named like defined in the `ODISS_KAFKA_KEYSTORE_FILE_NAME` and `ODISS_KAFKA_TRUSTSTORE_FILE_NAME`
variables.

Both files can be genereated for testing with the [Kafka Certificate generator](./SCIPTS.md#kafka-certificate-generator) script.

<a name="nginx_certs"></a>
### Nginx Certificate

The Nginx certificate is located in the `./config/nginx/certs/` folder. Nginx needs a `.crt` file and a `.key` file.

The files should be named like defined in the `ODISS_NGINX_CERT_FILE_NAME` and `ODISS_NGINX_KEY_FILE_NAME` variables.

