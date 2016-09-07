#!/bin/sh
set -e


TAG=`date +%s`
BUCKET=s3://${AWS_BUCKET}
MAX_SAVES=15


/usr/share/cassandra/bin/nodetool -h ${CASSANDRA_IP_ADDRESS} snapshot --tag ${TAG} ${KEYSPACES}

for keyspace in ${KEYSPACES}; do
  for dir in $CASSANDRA_HOME/data/data/${keyspace}/*/snapshot
  do
      echo "COPYING ${dir}/${TAG} TO s3"
      aws s3 cp --recursive ${dir}/${TAG} ${BUCKET}/${CASSANDRA_NODE_NUMBER}/${dir} ${keyspace}
      nodetool clearsnapshot -t ${TAG}

      # DELETE OLD BACKUPS
      NUM_SAVE=`aws s3 ls ${BUCKET}/${CASSANDRA_NODE_NUMBER}/${dir} | wc -l`
      if [ ${NUM_SAVE} -ge ${MAX_SAVES} ]; then
        OLDEST=`aws s3 ls ${BUCKET}/${CASSANDRA_NODE_NUMBER}/${dir} | awk 'NR==1'`

        aws s3 rm --recursive ${dir}/${OLDEST} ${BUCKET}/${CASSANDRA_NODE_NUMBER}/${dir}/${OLDEST}
      fi
  done
done
