#!/bin/sh
set -e

BUCKET=s3://${AWS_BUCKET}

DATA_PATH=${CASSANDRA_HOME}/data/data


LAST_SAVE=`aws s3 ls ${BUCKET} 2> /dev/null | tail -n 1 | rev | cut -d' ' -f1 | rev`
LAST_SAVE=${LAST_SAVE%/}

for keyspace in ${KEYSPACES}; do
  aws s3 cp --recursive ${BUCKET}/${LAST_SAVE}/${CASSANDRA_NODE_NUMBER}/${keyspace}/ ${DATA_PATH}/${keyspace}
  for table in ${DATA_PATH}/${keyspace}/*; do
    ${CASSANDRA_HOME}/bin/sstableloader -d ${CASSANDRA_IP_ADDRESS} ${DATA_PATH}/${keyspace}/${table##*/}
  done
done
