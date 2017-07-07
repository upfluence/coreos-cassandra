#!/bin/sh
set -e

TAG=`date +%y-%m-%d-%H`
BUCKET=s3://${AWS_BUCKET}
MAX_SAVES=15

DATA_PATH=$CASSANDRA_HOME/data/data

${CASSANDRA_HOME}/bin/nodetool -h ${CASSANDRA_IP_ADDRESS} snapshot --tag ${TAG} ${KEYSPACES}

for keyspace in ${KEYSPACES}; do
  for table in ${DATA_PATH}/${keyspace}/*; do
    aws s3 cp --recursive ${table}/snapshots/${TAG} ${BUCKET}/${TAG}/${CASSANDRA_NODE_NUMBER}${table#${DATA_PATH}}
  done

  # DELETE OLD BACKUPS
  NUM_SAVE=`aws s3 ls ${BUCKET} | wc -l`
  if [ ${NUM_SAVE} -ge ${MAX_SAVES} ]; then
    OLDEST=`aws s3 ls ${BUCKET} 2> /dev/null | head -n 1 | awk '{print $2}'`

    aws s3 rm --recursive ${BUCKET}/${OLDEST}/${CASSANDRA_NODE_NUMBER}
  fi

  ${CASSANDRA_HOME}/bin/nodetool -h ${CASSANDRA_IP_ADDRESS} clearsnapshot -t ${TAG} -- ${keyspace}
done
