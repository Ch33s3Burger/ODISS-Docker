
# Add Certificates for Nginx and Kafka

## Kafka Certificate

The Kafka certificate is located in the `./config/kafka/certs/` folder. Kafka needs a Keystore with a valid key within
and a Truststore. As default the certificates are from type `JKS`. If you would like to used `PEM` certificates you can
adjust the `ODISS_KAFKA_CERT_TYPE` variable.

The files should be named like defined in the `ODISS_KAFKA_KEYSTORE_FILE_NAME` and `ODISS_KAFKA_TRUSTSTORE_FILE_NAME`
variables. And the passwords should also be adjusted to the `ODISS_KAFKA_KEYSTORE_PASSWORD`,
`ODISS_KAFKA_KEY_PASSWORD`, `ODISS_KAFKA_TRUSTSTORE_PASSWORD` configurations.

Both files can be generated for testing. Just use option **3a.** in the [installation script](./INSTALLATION.md) 
and follow the script.

## Nginx Certificate

The Nginx certificate is located in the `./config/nginx/certs/` folder. Nginx needs a `.crt` file and a `.key` file.

The files should be named like defined in the `ODISS_NGINX_CERT_FILE_NAME` and `ODISS_NGINX_KEY_FILE_NAME` variables.

