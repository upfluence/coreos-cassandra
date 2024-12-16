FROM alpine:edge

ENV ENVTMPL_VERSION=0.0.2 \
    CASSANDRA_VERSION=4.0.15 \
    PROMETHEUS_EXPORTER=0.19.0 \
    LOGGER_LEVEL=INFO \
    CASSANDRA_HOME=/usr/share/cassandra

ENV ENVTPL_REPO=https://github.com/upfluence/envtmpl/releases/download/v${ENVTMPL_VERSION}/envtmpl-linux-amd64-${ENVTMPL_VERSION} \
    CASSANDRA_REPO=http://dlcdn.apache.org/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz \
    EXPORTER_REPO=https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${PROMETHEUS_EXPORTER}/jmx_prometheus_javaagent-${PROMETHEUS_EXPORTER}.jar

RUN apk add --update openjdk11 curl su-exec && \
    rm -rf /var/cache/apk/*

RUN curl -sL ${ENVTPL_REPO} > /usr/bin/envtmpl && \
    chmod +x /usr/bin/envtmpl

RUN curl -s ${CASSANDRA_REPO} | tar xz -C /usr/share && ln -s \
    /usr/share/apache-cassandra-${CASSANDRA_VERSION} /usr/share/cassandra

RUN curl -sL ${EXPORTER_REPO} > ${CASSANDRA_HOME}/lib/exporter.jar && \
    rm  ${CASSANDRA_HOME}/conf/cassandra.yaml && \
    rm  ${CASSANDRA_HOME}/conf/logback.xml && \
    mkdir /hints && mkdir ${CASSANDRA_HOME}/logs

ADD run.sh /usr/share/cassandra/run.sh

COPY config/* ${CASSANDRA_HOME}/config/

RUN chmod +x ${CASSANDRA_HOME}/run.sh && \
   sed -i -e "s/com.sun.management.jmxremote.authenticate=true/com.sun.management.jmxremote.authenticate=false/" ${CASSANDRA_HOME}/conf/cassandra-env.sh

VOLUME /usr/share/cassandra/data
EXPOSE 7000 7001 7777 7199 9042 9160

CMD ["/usr/share/cassandra/run.sh"]
