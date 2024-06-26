# Kafka Connect Sandbox

This repository refers to the code mentioned in the article available at https://estevaosaleme.medium.com/a-sandbox-for-kafka-connect-connectors-experimentation-2e41f99aae15

### What does this sandbox do?

- Spin up Apache Kafka.
- Build and spin up Kafka Connect.
- Spin up Kafkdrop - a UI for Apache Kafka.
- Spin up Confluent Kafka REST Proxy.
- Spin up a Prometheus server.
- Health check on Apache Kafka.
- Health check on Kafka Connect.
- Read data from a file and ingest data to Kafka (File source test).
- Read data from kafka and output it to a local file (File sink test).
- Read data from kafka and output it a database (Postgres sink test).
- Check the status of the source and sink connectors using Kafka Connect's API.

## Getting started
First, build the Kafka Connect image using docker-compose:

```bash
docker-compose build
```

Then, you should be able to run the environment:
```bash
docker-compose up
```

## Accessible endpoints
### Kafka Connect connectors
- http://localhost:8083/connector-plugins<br>

### Confluent REST Proxy
- http://localhost:8082<br>

### Kafdrop - Kafka UI
- http://localhost:9020<br>

### Prometheus UI endpoint
- http://localhost:9090<br>


## References
- Apache Kafka 3.7 documentation: https://kafka.apache.org/37/documentation.html
- Kafka Connect FileStream Connectors: https://docs.confluent.io/platform/current/connect/filestream_connector.html
- JDBC Sink Connector for Confluent Platform: https://docs.confluent.io/kafka-connectors/jdbc/current/sink-connector/overview.html
- Confluent REST Proxy for Apache Kafka: https://docs.confluent.io/platform/current/kafka-rest/index.html
