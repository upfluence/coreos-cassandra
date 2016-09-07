FROM alpine:3.4

ENV ENVTMPL_VERSION 0.0.1
ENV CASSANDRA_VERSION 3.0.8
ENV JOLOKIA_VERSION 1.3.3
ENV CASSANDRA_HOME /usr/share/cassandra
ENV COMMUNITY_REPO http://nl.alpinelinux.org/alpine/edge/community
ENV CASSANDRA_REPO http://apache.claz.org/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz
ENV JOLOKIA_REPO http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.3.3/jolokia-jvm-${JOLOKIA_VERSION}-agent.jar

RUN echo "@community ${COMMUNITY_REPO}" >> /etc/apk/repositories && \
    apk add --update openjdk8@community curl su-exec python python-dev py-pip && \
    rm -rf /var/cache/apk/* && \
    curl -s ${CASSANDRA_REPO} | tar xz -C /usr/share && ln -s \
    /usr/share/apache-cassandra-${CASSANDRA_VERSION} /usr/share/cassandra && \
    curl -sL ${JOLOKIA_REPO} > ${CASSANDRA_HOME}/lib/jolokia-jvm-agent.jar && \
    rm  ${CASSANDRA_HOME}/conf/cassandra.yaml && \
    pip install awscli


ADD run.sh /usr/share/cassandra/run.sh

RUN chmod +x ${CASSANDRA_HOME}/run.sh

CMD ["/usr/share/cassandra/run.sh"]
