FROM debian:sid-slim
USER root
RUN apt-get update && apt-get install -y curl
RUN echo "Downloading kafka_2.13-3.7.0.tgz..." \
  && curl -k --progress-bar -O "https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz" \
  && echo "Downloading jmx_prometheus_javaagent-1.0.1.jar..." \
  && curl -k --progress-bar -O "https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/1.0.1/jmx_prometheus_javaagent-1.0.1.jar" \
  && mkdir kafka \
  && echo "Extracting kafka_2.13-3.7.0.tgz to /kafka..." \
  && tar xf kafka_2.13-3.7.0.tgz -C kafka --strip-components 1 \
  && echo "Creating target directories..." \
  && mkdir -p /target/bin \
  && mkdir -p /target/config \
  && mkdir -p /target/tls \
  && mkdir -p /target/plugins \
  && mkdir -p /target/jmx-exporter \
  && echo "Copying Kafka Connect files to target directory..." \
  && cp -v kafka/LICENSE /target/LICENSE \
  && cp -v kafka/NOTICE /target/NOTICE \
  && cp -v kafka/bin/kafka-run-class.sh /target/bin/ \
  && cp -v kafka/bin/connect-standalone.sh /target/bin/ \
  && cp -rv kafka/libs /target \
  && cp -rv kafka/licenses /target \
  && cp -v jmx_prometheus_javaagent-1.0.1.jar /target/jmx-exporter/
COPY ./build-artifacts/connect-standalone.properties /target/config/
COPY ./build-artifacts/connect-log4j.properties /target/config/
COPY ./build-artifacts/connect-jmx-exporter.yml /target/jmx-exporter/

FROM eclipse-temurin:21.0.3_9-jdk
COPY --from=0 /target/ /opt/kafka/connect/
COPY ./build-artifacts/docker-entrypoint.sh /
ENV KAFKA_CONNECT_BIN="/opt/kafka/connect/bin/connect-standalone.sh"
ENV KAFKA_CONNECT_PROPERTIES_PATH="/opt/kafka/connect/config/connect-standalone.properties"
ENV JMX_EXPORTER_JAVA_AGENT_JAR_PATH="/opt/kafka/connect/jmx-exporter/jmx_prometheus_javaagent-1.0.1.jar"
ENV JMX_EXPORTER_CONFIG_PATH="/opt/kafka/connect/jmx-exporter/connect-jmx-exporter.yml"
ENV KAFKA_CONNECT_KEY_CONVERTER="org.apache.kafka.connect.converters.ByteArrayConverter"
ENV KAFKA_CONNECT_VALUE_CONVERTER="org.apache.kafka.connect.converters.ByteArrayConverter"
ENV KAFKA_HEAP_OPTS="-Xms256M -Xmx256M -XX:MaxMetaspaceSize=128M"
ENTRYPOINT ["/docker-entrypoint.sh"]
