#!/bin/sh

/usr/bin/envtmpl -i ${CASSANDRA_HOME}/config/cassandra.yaml.tmpl -o ${CASSANDRA_HOME}/conf/cassandra.yaml

echo "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=${CASSANDRA_IP_ADDRESS}\"" >> ${CASSANDRA_HOME}/conf/cassandra-env.sh
echo "JVM_OPTS=\"\$JVM_OPTS -javaagent:${CASSANDRA_HOME}/lib/jolokia-jvm-agent.jar=port=7777,host=0.0.0.0\"" >> ${CASSANDRA_HOME}/conf/cassandra-env.sh
echo "${CASSANDRA_IP_ADDRESS} `hostname`" > /etc/hosts

/usr/share/cassandra/bin/cassandra -f
