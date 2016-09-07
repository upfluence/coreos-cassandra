How to restore
=================

# Get last backup back from s3:

```sh
sudo docker exec -i -t cassandra-backup-<node_number> /bin/sh

aws s3 cp --recursive s3://<bucket>/<node_number>/<keyspace>/ /usr/share/cassandra/data/data/<keyspace> --exclude "*" --include "*/<timestamp of backup>/snapshots/*"
```

# Follow instructions from official doc:
https://docs.datastax.com/en/cassandra/3.0/cassandra/operations/opsBackupSnapshotRestore.html
