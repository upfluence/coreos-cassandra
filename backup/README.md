How to restore
=================

# Restore a node:

```sh
docker pull upfluence/cassandra-backup:latest
docker run -i -e CASSANDRA_IP_ADDRESS=<CASSANDRA_IP> \
            -e CASSANDRA_NODE_NUMBER=<NODE_NUMBER> \
            -e AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY> \
            -e AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_KEY> \
            -e AWS_BUCKET=<YOUR_AWS_BUCKET> \
            -e KEYSPACES=<YOUR_KEYSPACES_SPLIT_WITH_SPACES> \
            -v /var/cassandra:/usr/share/cassandra/data/ \
            upfluence/cassandra-backup:latest \
            /usr/share/cassandra/backup.sh
```
