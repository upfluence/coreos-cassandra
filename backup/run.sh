#!/bin/sh
set -e


TAG=`date +%y-%m-%d-%H`
BUCKET=s3://${AWS_BUCKET}
MAX_SAVES=15

DATA_PATH=$CASSANDRA_HOME/data/data


/usr/share/cassandra/bin/nodetool -h ${CASSANDRA_IP_ADDRESS} snapshot --tag ${TAG} ${KEYSPACES}

for keyspace in ${KEYSPACES}; do
  for table in ${DATA_PATH}/${keyspace}/*; do
    aws s3 cp --recursive ${table}/snapshots/${TAG} ${BUCKET}/${TAG}/${CASSANDRA_NODE_NUMBER}${table#${DATA_PATH}}

    # DELETE OLD BACKUPS
    NUM_SAVE=`aws s3 ls ${BUCKET} | wc -l`
    if [ ${NUM_SAVE} -ge ${MAX_SAVES} ]; then
      OLDEST=`aws s3 ls ${BUCKET} 2> /dev/null | head -n 1`

      aws s3 rm --recursive ${BUCKET}/${TAG}/${CASSANDRA_NODE_NUMBER}/${table}/${OLDEST}
    fi
  done

  ${CASSANDRA_HOME}/bin/nodetool -h ${CASSANDRA_IP_ADDRESS} clearsnapshot -t ${TAG} -- ${keyspace}
done
