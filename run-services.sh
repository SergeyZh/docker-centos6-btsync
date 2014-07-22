#!/bin/sh


NODENAME=`hostname -s`

sed -i "s/MY_SECRET_1/${STORAGE_SECRET}/" btsync.conf
sed -i "s/\"device_name\": \"My Sync Device\",/\"device_name\": \"${NODENAME}\",/" btsync.conf

/btsync --config /btsync.conf --nodaemon



