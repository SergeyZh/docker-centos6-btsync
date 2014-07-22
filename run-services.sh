#!/bin/sh


NODENAME=`hostname -s`

if [ -z "${STORAGE_SECRET}" ] ; then
    echo "Can't run without environment variable STORAGE_SECRET ! Exiting..."
    exit 1
fi

if [ ! -z "`grep MY_SECRET_1 btsync.conf`" ] ; then
    echo "Configuring btsync ..."
    echo "Node name: ${NODENAME}"
    sed -i "s/MY_SECRET_1/${STORAGE_SECRET}/" btsync.conf
    sed -i "s/\"device_name\": \"My Sync Device\",/\"device_name\": \"${NODENAME}\",/" btsync.conf
fi

shutdown_btsync()
{
    echo "Stopping container..."
    killall btsync
    while [ ! -z "`ps x | grep btsync`" ] ; do echo -n "." ; sleep 1 ; done
    exit 0
}

trap shutdown_btsync SIGINT SIGTERM SIGHUP

/btsync --config /btsync.conf --nodaemon &

wait
