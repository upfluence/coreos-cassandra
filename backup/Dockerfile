FROM alpine:3.4

ENV ENVTMPL_VERSION 0.0.1
ENV CASSANDRA_VERSION 3.0.8
ENV JOLOKIA_VERSION 1.3.3
ENV CASSANDRA_HOME /usr/share/cassandra
ENV COMMUNITY_REPO http://nl.alpinelinux.org/alpine/edge/community
ENV ENVTPL_REPO https://github.com/upfluence/envtmpl/releases/download/v${ENVTMPL_VERSION}/envtmpl-linux-amd64-${ENVTMPL_VERSION}
ENV CASSANDRA_REPO http://apache.claz.org/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz
ENV JOLOKIA_REPO http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.3.3/jolokia-jvm-${JOLOKIA_VERSION}-agent.jar

RUN echo "@community ${COMMUNITY_REPO}" >> /etc/apk/repositories && \
    apk add --update openjdk8@community curl su-exec python python-dev unzip && \
    rm -rf /var/cache/apk/* && \
    curl -sL ${ENVTPL_REPO} > /usr/bin/envtmpl && \
    chmod +x /usr/bin/envtmpl &&\
    curl -s ${CASSANDRA_REPO} | tar xz -C /usr/share && ln -s \
    /usr/share/apache-cassandra-${CASSANDRA_VERSION} /usr/share/cassandra && \
    curl -sL ${JOLOKIA_REPO} > ${CASSANDRA_HOME}/lib/jolokia-jvm-agent.jar && \
    rm  ${CASSANDRA_HOME}/conf/cassandra.yaml && \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    mkdir -p ~/.aws && rm -rf awscli-bundle.zip awscli-bundle

ENV LOCAL_JMX no


ADD run.sh /usr/share/cassandra/run.sh
ADD aws/config ~/.aws/config
ADD aws/credentials.tmpl ~/.aws/credentials.tmpl

RUN chmod +x ${CASSANDRA_HOME}/run.sh

CMD ["/usr/share/cassandra/run.sh"]
