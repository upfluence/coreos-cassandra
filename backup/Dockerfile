FROM upfluence/cassandra

RUN apk add --update python python-dev py-pip && \
    rm -rf /var/cache/apk/* && \
    pip install awscli

ADD run.sh ${CASSANDRA_HOME}/run.sh
ADD restore.sh ${CASSANDRA_HOME}/restore.sh

RUN chmod +x ${CASSANDRA_HOME}/run.sh ${CASSANDRA_HOME}/restore.sh
