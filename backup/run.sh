#!/bin/sh
set -e


TAG=`date +%s`
BUCKET=s3://cassandra-backups-upfluence
MAX_SAVES=15

/usr/bin/envtmpl -i ~/.aws/credentials.tmpl -o ~/.aws/credentials

/usr/share/cassandra/bin/nodetool -h ${CASSANDRA_IP_ADDRESS} snapshot --tag ${TAG} tracking

for dir in $CASSANDRA_HOME/data/data/tracking/*/snapshot
do
    echo "COPYING ${dir}/${TAG} TO s3"
    aws s3 cp --recursive ${dir}/${TAG} ${BUCKET}/${CASSANDRA_NODE_NUMBER}/${dir}${TAG}

    # DELETE OLD BACKUPS
    NUM_SAVE=`ls -tr ${dir} | wc -l`

    if [ ${NUM_SAVE} -ge ${MAX_SAVES} ]; then
      OLDEST=`ls -tr ${dir} | awk 'NR==1'`
      nodetool clearsnapshot -t ${OLDEST}

      aws s3 rm --recursive ${dir}/${OLDEST} ${BUCKET}/${CASSANDRA_NODE_NUMBER}/${dir}/${OLDEST}
    fi
done
