FROM alpine:3.3

ENV ENVTMPL_VERSION=0.0.1 \
    CASSANDRA_VERSION=3.0.8 \
    JOLOKIA_VERSION=1.3.3 \
    CASSANDRA_HOME=usr/share/cassandra \
    COMMUNITY_REPO=http://nl.alpinelinux.org/alpine/edge/community

ENV ENVTPL_REPO=https://github.com/upfluence/envtmpl/releases/download/v${ENVTMPL_VERSION}/envtmpl-linux-amd64-${ENVTMPL_VERSION} \
    CASSANDRA_REPO=http://apache.claz.org/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz \
    JOLOKIA_REPO=http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.3.3/jolokia-jvm-${JOLOKIA_VERSION}-agent.jar

RUN echo "@community ${COMMUNITY_REPO}" >> /etc/apk/repositories && \
    apk add --update openjdk8@community curl su-exec && \
    rm -rf /var/cache/apk/* && \
    curl -sL ${ENVTPL_REPO} > /usr/bin/envtmpl && \
    chmod +x /usr/bin/envtmpl &&\
    curl -s ${CASSANDRA_REPO} | tar xz -C /usr/share && ln -s \
    /usr/share/apache-cassandra-${CASSANDRA_VERSION} /usr/share/cassandra && \
    curl -sL ${JOLOKIA_REPO} > ${CASSANDRA_HOME}/lib/jolokia-jvm-agent.jar && \
    rm  ${CASSANDRA_HOME}/conf/cassandra.yaml

ENV LOCAL_JMX no

ADD run.sh /usr/share/cassandra/run.sh
ADD config/cassandra.yaml.tmpl ${CASSANDRA_HOME}/config/cassandra.yaml.tmpl

RUN chmod +x ${CASSANDRA_HOME}/run.sh && \
   sed -i -e "s/com.sun.management.jmxremote.authenticate=true/com.sun.management.jmxremote.authenticate=false/" ${CASSANDRA_HOME}/conf/cassandra-env.sh

VOLUME /usr/share/cassandra/data
EXPOSE 7000 7001 7199 9042 9160

CMD ["/usr/share/cassandra/run.sh"]
