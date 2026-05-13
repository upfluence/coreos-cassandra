FROM alpine:3.21

ENV ENVTMPL_VERSION=0.0.5 \
    CASSANDRA_VERSION=5.0.8 \
    PROMETHEUS_EXPORTER=1.5.0 \
    LOGGER_LEVEL=INFO \
    CASSANDRA_HOME=/usr/share/cassandra

ENV ENVTPL_REPO=https://github.com/upfluence/envtmpl/releases/download/v${ENVTMPL_VERSION}/envtmpl-linux-amd64 \
    CASSANDRA_REPO=https://archive.apache.org/dist/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz \
    EXPORTER_REPO=https://github.com/prometheus/jmx_exporter/releases/download/${PROMETHEUS_EXPORTER}/jmx_prometheus_javaagent-${PROMETHEUS_EXPORTER}.jar

RUN apk add --no-cache openjdk17 curl && \
    curl -sL ${ENVTPL_REPO} > /usr/bin/envtmpl && \
    chmod +x /usr/bin/envtmpl && \
    curl -sLf ${CASSANDRA_REPO} | tar xz -C /usr/share && \
    ln -s /usr/share/apache-cassandra-${CASSANDRA_VERSION} /usr/share/cassandra && \
    curl -sL ${EXPORTER_REPO} > ${CASSANDRA_HOME}/lib/exporter.jar && \
    rm ${CASSANDRA_HOME}/conf/cassandra.yaml && \
    rm ${CASSANDRA_HOME}/conf/logback.xml && \
    mkdir /hints && \
    mkdir ${CASSANDRA_HOME}/logs && \
    sed -i -e "s/com.sun.management.jmxremote.authenticate=true/com.sun.management.jmxremote.authenticate=false/" ${CASSANDRA_HOME}/conf/cassandra-env.sh && \
    ln -s ${CASSANDRA_HOME}/bin/nodetool /usr/local/bin/nodetool

COPY run.sh ${CASSANDRA_HOME}/run.sh
COPY config/* ${CASSANDRA_HOME}/config/

RUN chmod +x ${CASSANDRA_HOME}/run.sh

VOLUME /usr/share/cassandra/data
VOLUME /usr/share/cassandra/logs
EXPOSE 7000 7001 7777 7199 9042 9160

ENTRYPOINT ["/usr/share/cassandra/run.sh"]
